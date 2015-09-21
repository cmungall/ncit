#!/usr/bin/perl
while(<>) {
    s@NCITID__@NCIT:@g;
    if (m@id: (\S+)@) {
        $id = $1;
    }
    s@property_value: DEFINITION "<ncicp:ComplexDefinition><ncicp:def-definition>(.*)</ncicp:def-definition><ncicp:def-source>NCI</ncicp:def-source></ncicp:ComplexDefinition>.*@def: "$1" [$id]\n@;
    s@property_value: FULL_SYN "<ncicp:ComplexTerm><ncicp:term-name>(.*)</ncicp:term-name>.*@synonym: "$1" RELATED [$id]\n@;
    s@property_value: UMLS_CUI "(\S+)" xsd:string@xref: UMLS:$1\n@;
    s@property_value: code "(\S+)" xsd:string@xref: NCIT:$1\n@;
    print;
}
