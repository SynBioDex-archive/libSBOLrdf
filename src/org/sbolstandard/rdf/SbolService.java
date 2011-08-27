/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sbolstandard.rdf;

import com.clarkparsia.empire.Empire;
import com.clarkparsia.empire.impl.RdfQuery;
import com.clarkparsia.empire.sesametwo.OpenRdfEmpireModule;
import com.clarkparsia.openrdf.ExtGraph;
import com.clarkparsia.openrdf.ExtRepository;
import com.clarkparsia.openrdf.OpenRdfUtil;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import org.openrdf.repository.RepositoryException;
import org.openrdf.rio.turtle.TurtleWriter;
import java.io.UnsupportedEncodingException;
import java.net.URI;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.persistence.spi.PersistenceProvider;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFParseException;

/**
 * SbolService provides the methods for making new SBOL objects and adding SBOL
 * data.
 *
 * Use methods of SbolService when creating new SBOL objects and adding data.
 * It is called a service as it performs operations on the SBOL objects that do
 * not really belong to the class itself. These convenience methods SHOLD include
 * an entity manager from empire, delete methods, creating entities SHOULD check
 * for previously existing objects and eventually should be the only way most
 * applications interact with the SBOL API.
 * 
 * inspired by examples on: http://www.java2s.com/Code/Java/JPA
 * it should do more of the things found in the intro to jpa:
 * http://www.javaworld.com/javaworld/jw-01-2008/jw-01-jpa1.html
 * @todo update and delete methods.
 *
 * @author mgaldzic
 * @since 0.31, 03/2/2011
 */
public class SbolService {
    // there was a naming issue for SbolService, it will temporarily be SbolService,
    // until we go back to strick camel case or make another naming decision

    private EntityManager aManager = null;
    static final String DATA_NAMESPACE_DEFAULT = "http://sbols.org/data#";

    public SbolService() {
        
        Empire.init(new OpenRdfEmpireModule());
        aManager = Persistence.createEntityManagerFactory("blank-data-source").createEntityManager();
 
    }

    public SbolService(String rdfString, RDFFormat format) {
        this();
        InputStream is = null;
        try {
            ExtRepository aRepo = OpenRdfUtil.createInMemoryRepo();
            is = new ByteArrayInputStream(rdfString.getBytes("UTF-8"));
            try {
                aRepo.read(is, format);
            } catch (IOException ex) {
                Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, null, ex);
            } catch (RDFParseException ex) {
                Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, null, ex);
            }
            Map aMap = new HashMap();
            //aMap.put("annotation.index", "config//libSBOLj.empire.annotation.config");
            aMap.put("name", "michal");
            aMap.put("factory", "sesame");
            //aMap.put("files", "data//blank.rdf");
            aMap.put("repo_handle", aRepo);

            PersistenceProvider aProvider = Empire.get().persistenceProvider();
            aManager = aProvider.createEntityManagerFactory("existingRDF", aMap).createEntityManager();
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                is.close();
            } catch (IOException ex) {
                Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }

    /**
     * Builds a new DnaSequence using a string of dna sequence is input.
     *
     * @param dnaSequence a string with a sequence of [a|c|t|g] letters
     *
     * @see DnaSequence#setDnaSequence
     * 
     * @return DnaSequence can be used as the sequence of a DnaComponent or
     * SequenceFeature
     */
    public DnaSequence createDnaSequence(String dnaSequence) {
        DnaSequence aDS = new DnaSequence();
        aDS.setDnaSequence(dnaSequence);
        aManager.persist(aDS);
        return aDS;
    }

    /**
     * Builds a new SequenceFeature which SequenceAnnotations can point to.
     *
     * @param displayId A human readable identifier
     * @param name commonly used to refer to this SequenceFeature (eg. pLac-O1)
     * @param description human readable text describing the feature
     * @param type Sequence Ontology vocabulary term describing the kind of thing
     * the feature is
     * @return a SequenceFeature which can be used to describe a SequenceAnnotation
     *
     * @see SequenceFeature
     */
    public SequenceFeature createSequenceFeature(String displayId, String name,
            String description, String type) {
        SequenceFeature aSF = new SequenceFeature();
        aSF.setDisplayId(displayId);
        aSF.setName(name);
        aSF.setDescription(description);
        aSF.addType(URI.create("http://purl.org/obo/owl/SO#" + type));
        aManager.persist(aSF);
        return aSF;
    }

    /**
     * Builds a new SequenceAnnotation to describe a segment of the DnaComponent.
     *
     * Links the SequenceAnnotation to the component, it can only describe one
     * DnaComponent. (But, SequenceFeatures are to be re-used, when the same one
     * is describes multiple DnaCompenents)
     *
     * @param start coordinate of first base of the SequenceFeature
     * @param stop coordinate of last base of the SequenceFeature
     * @param strand <code>+</code> if feature aligns in same direction as DnaComponent,
     *               <code>-</code> if feature aligns in opposite direction as DnaComponent.
     * @return a SequenceAnnotation made to annotate a DnaComponent
     *
     * @see SequenceAnnotation#setStrand(java.lang.String)
     */
    public SequenceAnnotation createSequenceAnnotationForDnaComponent(Integer start,
            Integer stop, String strand, SequenceFeature feature, DnaComponent component) {
        SequenceAnnotation aSA_SF = new SequenceAnnotation();
        aSA_SF.setStart(start);
        aSA_SF.setStop(stop);
        aSA_SF.setStrand(strand);
        aSA_SF.addFeature(feature);
        aSA_SF.generateId(component);
        component.addAnnotation(aSA_SF);

        if (aManager.contains(aSA_SF)) {
            aManager.merge(aSA_SF);
        } else {
            aManager.persist(aSA_SF);
        }

        if (aManager.contains(component)) {
            aManager.merge(component);
        } else {
            aManager.persist(component);
        }
        return aSA_SF;
    }

    /**
     * Links SequenceFeature to its SequenceAnnotation.
     *
     * @param feature description of the position
     * @param annotation position information for a DnaComponent being described
     * @return The linked SequenceAnnotation. //WHY? here is an example of when
     * objects should be kept in a entity manager
     */
    public SequenceAnnotation addSequenceFeatureToSequenceAnnotation(
            SequenceFeature feature, SequenceAnnotation annotation) {
        annotation.addFeature(feature);
        if (aManager.contains(annotation)) {
            aManager.merge(annotation);
        } else {
            aManager.persist(annotation);
        }

        return annotation;
    }

    /**
     * Builds a new DnaComponent to describe and add to Library
     *
     * @param displayId    human readable identifier
     * @param name         commonly used to refer to this DnaComponent
     *                     (eg. pLac-O1)
     * @param description  human readable text describing the component
     * @param isCircular   <code>true</code> if DNA is circular
     *                     <code>false</code> if DNA is linear
     * @param type         Sequence Ontology vocabulary term specifying the kind
     *                     of thing the DnaComponent is
     * @param dnaSequence  previously created DnaSequence of this DnaComponent
     *

     * @return DnaComponent which should be added to a Library
     * @see DnaComponent#setDisplayId(java.lang.String)
     * @see DnaComponent#setName(java.lang.String)
     * @see DnaComponent#setDescription(java.lang.String)
     * @see DnaComponent#setCircular(boolean)
     * @see DnaComponent#setDnaSequence(org.sbolstandard.libSBOLj.DnaSequence)
     */
    public DnaComponent createDnaComponent(String displayId, String name,
            String description, Boolean isCircular, String type,
            DnaSequence dnaSequence) {
        DnaComponent aDC = new DnaComponent();
        aDC.setDisplayId(displayId);
        aDC.setName(name);
        aDC.setDescription(description);
        aDC.setCircular(isCircular);

        aDC.setDnaSequence(dnaSequence);
        aManager.persist(aDC);

        return aDC;
    }

    /**
     * Builds a new Library, ready to collect any DnaComponents or Features.
     *
     * A Library is the primary object that holds everything to exchange via SBOL.
     * Create one, and then add DnaComponents and/or SequenceFeatures to it,
     * then send it to a friend or another SBOL application.
     *
     * @param displayId A human readable identifier
     * @param name commonly used to refer to this Library (eg BIOAFAB Pilot Project)
     * @param description human readable text describing the Library (eg Pilot Project Designs, see http://biofab.org/data)
     * @return a Library with the metadata fields set, empty otherwise (ie no components or features)
     */
    public Library createLibrary(String displayId, String name, String description) {
        Library aL = new Library();
        aL.setDisplayId(displayId);
        aL.setName(name);
        aL.setDescription(description);
        aManager.persist(aL);

        return aL;
    }

    /**
     * Link the DnaComponent into a Library for organizing it as a list of components
     * that can be re-used, exchanged with another application, or published on the web.
     *
     * @param component a DnaComponent that is to be part of the Library
     * @param library a Library which will hold this DnaComponent
     * @return the Library with the DnaComponent inside
     */
    public Library addDnaComponentToLibrary(DnaComponent component, Library library) {
        library.addComponent(component);
        if (aManager.contains(library)) {
            aManager.merge(library);
        } else {
            aManager.persist(library);
        }

        return library;
    }

    /**
     * Link the SequenceFeature into a Library for organizing it as a list of
     * features that can be re-used, exchanged with another application, or published
     * on the web.
     *
     * Features do not have to describe components. They are useful on their own
     * if you want to take a library of features and annotate your own DnaComponents,
     * also known as, DNA constructs, with them.
     *
     * @param feature SequenceFeature to be added to a Library
     * @param library Library that will hold the SequenceFeature
     * @return
     */
    public Library addSequenceFeatureToLibrary(SequenceFeature feature, Library library) {
        library.addFeature(feature);
        if (aManager.contains(library)) {
            aManager.merge(library);
        } else {
            aManager.persist(library);
        }

        return library;
    }

    public String getAllAsRdf(RDFFormat mimetype) {
        String rdfString = null;
        Query aQuery = aManager.createQuery("CONSTRUCT {?s ?p ?o} WHERE {?s ?p ?o.}");

        ExtGraph singleResult = (ExtGraph) aQuery.getSingleResult();

        StringWriter out = new StringWriter();
        //StringWriter out1 = new TurtleWriter(out);
        //RDFXMLPrettyWriter rdfWriter = new RDFXMLPrettyWriter(out);

        try {
            if (mimetype.equals(RDFFormat.RDFXML)) {
               singleResult.write(out, RDFFormat.RDFXML);

            } else if (mimetype.equals(RDFFormat.TURTLE)) {
                singleResult.write(out, RDFFormat.TURTLE);
            }
            rdfString = out.toString();

        } catch (IOException ex) {
            Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rdfString;
    }

    public Library getLibrary() {
        Library findMe = null;
        Query aQuery = aManager.createQuery("WHERE {?result rdf:type sbol:Library}");
        aQuery.setHint(RdfQuery.HINT_ENTITY_CLASS, Library.class);
        List aResults = aQuery.getResultList();
        if (aResults.size() > 0) {
            findMe = (Library) aResults.get(0);
        } else {
            Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, "Empty Library: no results found", this);

        }
        //Library lib = aManager.find(Library.class, findMe.getRdfId());

        return findMe;
    }

    //This doesnt do what it implies, put the id searching back in
    public Library getLibrary(String id) {
        Library findMe = null;
        Query aQuery = aManager.createQuery("WHERE {?result rdf:type sbol:Library}");
        aQuery.setHint(RdfQuery.HINT_ENTITY_CLASS, Library.class);
        List aResults = aQuery.getResultList();
        if (aResults.size() > 0) {
            Library findMe1 = (Library) aResults.get(0);
        } else {
            Logger.getLogger(SbolService.class.getName()).log(Level.SEVERE, "Empty Library: no results found", this);

        }
        Library lib = aManager.find(Library.class, findMe.getRdfId());

        return lib;
    }

    public DnaComponent addSequenceAnnotationToDnaComponent(SequenceAnnotation annotation, DnaComponent component) {

        component.addAnnotation(annotation);
        if (aManager.contains(component)) {
            aManager.merge(component);
        } else {
            aManager.persist(component);
        }
        return component;
    }

    /**
     * Adds the Library given as input to the SbolService.
     *
     * If you already have a Library of components and features, you can add it
     * directly to the SbolService, to get the benefits of SBOL data persistence services.
     * 
     * @param a Library with the metadata fields set, empty otherwise (ie no components or features)
     */
    public void insertLibrary(Library lib) {
        aManager.persist(lib);
    }

    public void insertDnaComponent(DnaComponent comp) {
        aManager.persist(comp);
    }

    public void insertSequenceAnnotation(SequenceAnnotation anot) {
        aManager.persist(anot);
    }

    public void insertSequenceFeature(SequenceFeature feat) {
        aManager.persist(feat);
    }
}
