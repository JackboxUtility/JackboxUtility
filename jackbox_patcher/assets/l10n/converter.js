// File converting all the untranslated messages into the other languages file 

// If you are in this file, you probably want to run this command: node converter.js
// And if you are in this file and you want to translate the app in another language, join our discord !

var languages = ["fr","es","de","uk","be","ca","ru"]
var fs = require("fs")
var englishFile = "app_en.arb"
var english = JSON.parse(fs.readFileSync(englishFile))

for (var language of languages){
    var file = fs.readFileSync("app_"+language + ".arb")
    var notTranslatedFile = "../../untranslated_messages.json"
    var notTranslated = JSON.parse(fs.readFileSync(notTranslatedFile))
    var json = JSON.parse(file)
    var newJson = {}
    for (var key in notTranslated[language]){
        json[notTranslated[language][key]] = "EN:"+english[notTranslated[language][key]]
    }
    fs.writeFileSync("app_"+language + ".arb", JSON.stringify(json))
}