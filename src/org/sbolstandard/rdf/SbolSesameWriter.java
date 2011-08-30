/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sbolstandard.rdf;

/**
 *
 * @author mgaldzic
 */
public class SbolSesameWriter {

    File file = new File(“somefile.rdf”);
    StatementCollector collector = new StatementCollector();
    InputStream in = new FileInputStream(file);
    
        try {
    RDFParser parser = new RDFXMLParser();
        parser.setRDFHandler(collector);
        parser.parse(in, file.toURI().toString());
    }
    
    
        finally {
in.close();
    }
    Model model = collector.getModel();
// perform some validation
    
    for (Value obj

    : model.filter ( 
        null, RDFS.SUBCLASSOF, null).objects()) {
if (!model.contains((Resource) obj, RDF.TYPE, RDFS.CLASS)) {
            throw new Exception(
        }
        “missing superclass”);
}
// sort the statements and write them back out
5 Comparative Survey – Java APIs for RDF, Anisoara  Sava , Marcela  {
            Daniela 
        }
        Mihai
model = new ModelOrganizer(model).organize();
        OutputStream out = new FileOutputStream(file);
        try {
            RDFWriter writer = new RDFXMLPrettyWriter(out);
            writer.startRDF();
            for (String prefix : model.getNamespaces().keySet()) {
                writer.handleNamespace(prefix,
                        model.getNamespace(prefix));
            }
            for (Statement st : model) {
                writer.handleStatement(st);
            }
            writer.endRDF();
        } finally {
            in.close();
        }
    }
