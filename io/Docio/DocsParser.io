Markdown

//metadoc DocsParser category API
DocsParser := Object clone do(
    //doc DocsParser docsMap The map generated after parse process.
    docsMap := Map clone

    //doc DocsParser parse Parses `docs.txt` generated by [DocsExtractor] and fills up the `docsMap`.
    parse := method(
        docsTxt := Docio getDocsTxt()
        docsTxt contents split("------" .. _lineBreak) foreach(entry, parseEntry(entry))
    )

    parseEntry := method(docEntry,
        header := docEntry beforeSeq(_lineBreak) afterSeq(" ") 
        if(header, parseHeader(header, docEntry))
    )

    parseHeader := method(header, docEntry,
        headerCopy := header asMutable strip asSymbol
        protoName := headerCopy beforeSeq(" ") ?asMutable ?strip ?asSymbol
        docsMap atIfAbsentPut(protoName, Map clone atPut("slots", Map clone))
        if(protoName == nil, writeln("ERROR: " .. headerCopy))
        parseSlot(headerCopy, docEntry, protoName)
    )

    parseSlot := method(header, docEntry, protoName,
        slotName := header afterSeq(" ") ?asMutable ?strip ?asSymbol
        if(slotName == nil, writeln("ERROR: " .. header))
        description := docEntry afterSeq(_lineBreak) markdownToHTML

        isSlot := docEntry beginsWithSeq("doc")
        if(isSlot, 
            docsMap at(protoName) at("slots") atPut(slotName, description)
            ,
            docsMap at(protoName) atPut(slotName, description)
        )
    )

    _lineBreak := method(
        os := System platform asLowercase
        if((os == "windows") or (os == "mingw"),
            return "\r\n"
            ,
            return "\n"
        )
    )

)

DocsParser clone := DocsParser
