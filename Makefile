all: ncit_anatomy.obo

Thesaurus.owl:
	wget -N http://ncicb.nci.nih.gov/xml/owl/EVS/$@
xThesaurus.owl: Thesaurus.owl
	./fix-hash.pl $< > $@
xThesaurus.obo: xThesaurus.owl
	owltools $< -o -f obo $@
Thesaurus.obo: xThesaurus.obo
	././fix-props.pl $< > $@
	#perl -npe 's@NCITID__@ncithesaurus:@g' $< > $@
	#perl -npe 's@http://purl.obolibrary.org/obo/ncit_@ncithesaurus:@g' $< > $@

ncit_anatomy.obo: Thesaurus.obo
	blip ontol-query -i $<  -query "(subclassRT(ID,'NCIT:C12219');subclassRT(ID,'NCIT:C22188');subclassRT(ID,'NCIT:C70699'))" -to obo > $@.tmp && ./downcase.pl $@.tmp > $@

ncit_exposure.obo: Thesaurus.obo
	blip ontol-query -i $<  -query "(subclassRT(ID,'NCIT:C17941'))" -to obo > $@.tmp && ./downcase.pl $@.tmp > $@

ncit_disease.obo: Thesaurus.obo
	blip ontol-query -i $<  -query "(subclassRT(ID,'ncithesaurus:Diseases_Disorders_and_Findings'))" -to obo > $@.tmp && ./downcase.pl $@.tmp > $@

ncit_process.obo: Thesaurus.obo
	blip ontol-query -i $<  -query "(class(R,'Biological Process'),subclassRT(ID,R))" -to obo > $@.tmp && ./downcase.pl $@.tmp > $@

t.obo:
	grep -v ^property_value: Thesaurus.obo > $@
t2.obo: t.obo
	owltools $< --remove-axiom-annotations -o -f obo --no-check $@
.PRECIOUS: t2.obo

neoplasm.obo: 
	blip ontol-query -r ncit  -query "(subclassRT(ID,'ncithesaurus:Neoplasm'))" -to obo > $@.tmp && ./downcase.pl $@.tmp > $@

%-lite.obo: %.obo
	grep -v ^property_value: $<  | grep -v ^def | grep -v ^syn > $@

%.omn: %.obo
	owltools $< --remove-axiom-annotations -o -f omn --prefix ncit http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl# --prefix obo http://purl.obolibrary.org/obo/ --prefix oio http://www.geneontology.org/formats/oboInOwl# $@
