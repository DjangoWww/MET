//
//  ServerObjectModelRes.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import Foundation

/// the result for Object request
/// - Parameters:
///   - total: The total number of publicly-available objects
///   - objectID    int    Identifying number for each artwork (unique, can be used as key field)    437133
///   - isHighlight    boolean    When "true" indicates a popular and important artwork in the collection    Vincent van Gogh's "Wheat Field with Cypresses"
///   - accessionNumber    string    Identifying number for each artwork (not always unique)    "67.241"
///   - accessionYear    string    Year the artwork was acquired.    "1921"
///   - isPublicDomain    boolean    When "true" indicates an artwork in the Public Domain    Vincent van Gogh's "Wheat Field with Cypresses"
///   - primaryImage    string    URL to the primary image of an object in JPEG format    "https://images.metmuseum.org/CRDImages/ep/original/DT1567.jpg"
///   - primaryImageSmall    string    URL to the lower-res primary image of an object in JPEG format    "https://images.metmuseum.org/CRDImages/ep/web-large/DT1567.jpg"
///   - additionalImages    array    An array containing URLs to the additional images of an object in JPEG format    ["https://images.metmuseum.org/CRDImages/ep/original/LC-EP_1993_132_suppl_CH-004.jpg", "https://images.metmuseum.org/CRDImages/ep/original/LC-EP_1993_132_suppl_CH-003.jpg", "https://images.metmuseum.org/CRDImages/ep/original/LC-EP_1993_132_suppl_CH-002.jpg", "https://images.metmuseum.org/CRDImages/ep/original/LC-EP_1993_132_suppl_CH-001.jpg"]
///   - constituents    array    An array containing the constituents associated with an object, with the constituent's role, name, ULAN URL, Wikidata URL, and gender, when available (currently contains female designations only).    [{"constituentID": 161708,"role": "Artist","name": "Louise Bourgeois","constituentULAN_URL": "http://vocab.getty.edu/page/ulan/500057350","constituentWikidata_URL": "https://www.wikidata.org/wiki/Q159409","gender": "Female"}]
///   - department    string    Indicates The Met's curatorial department responsible for the artwork    "Egyptian Art"
///   - objectName    string    Describes the physical type of the object    "Dress", "Painting", "Photograph", or "Vase"
///   - title    string    Title, identifying phrase, or name given to a work of art    "Wheat Field with Cypresses"
///   - culture    string    Information about the culture, or people from which an object was created    "Afghan", "British", "North African"
///   - period    string    Time or time period when an object was created    "Ming dynasty (1368-1644)", "Middle Bronze Age"
///   - dynasty    string    Dynasty (a succession of rulers of the same line or family) under which an object was created    "Kingdom of Benin", "Dynasty 12"
///   - reign    string    Reign of a monarch or ruler under which an object was created    "Amenhotep III", "Darius I", "Louis XVI"
///   - portfolio    string    A set of works created as a group or published as a series.    "Birds of America", "The Hudson River Portfolio", "Speculum Romanae Magnificentiae"
///   - artistRole    string    Role of the artist related to the type of artwork or object that was created    "Artist for Painting", "Designer for Dress"
///   - artistPrefix    string    Describes the extent of creation or describes an attribution qualifier to the information given in the artistRole field    "In the Style of", "Possibly by", "Written in French by"
///   - artistDisplayName    string    Artist name in the correct order for display    "Vincent van Gogh"
///   - artistDisplayBio    string    Nationality and life dates of an artist, also includes birth and death city when known.    "Dutch, Zundert 1853–1890 Auvers-sur-Oise"
///   - artistSuffix    string    Used to record complex information that qualifies the role of a constituent, e.g. extent of participation by the Constituent (verso only, and followers)    "verso only"
///   - artistAlphaSort    string    Used to sort artist names alphabetically. Last Name, First Name, Middle Name, Suffix, and Honorific fields, in that order.    "Gogh, Vincent van"
///   - artistNationality    string    National, geopolitical, cultural, or ethnic origins or affiliation of the creator or institution that made the artwork    "Spanish"; "Dutch"; "French, born Romania"
///   - artistBeginDate    string    Year the artist was born    "1840"
///   - artistEndDate    string    Year the artist died    "1926"
///   - artistGender    string    Gender of the artist (currently contains female designations only)    "female"
///   - artistWikidata_URL    string    Wikidata URL for the artist    "https://www.wikidata.org/wiki/Q694774"
///   - artistULAN_URL    string    ULAN URL for the artist    "https://vocab.getty.edu/page/ulan/500003169"
///   - objectDate    string    Year, a span of years, or a phrase that describes the specific or approximate date when an artwork was designed or created    "1865–67", "19th century", "ca. 1796"
///   - objectBeginDate    int    Machine readable date indicating the year the artwork was started to be created    1867, 1100, -900
///   - objectEndDate    int    Machine readable date indicating the year the artwork was completed (may be the same year or different year than the objectBeginDate)    1888, 1100, -850
///   - medium    string    Refers to the materials that were used to create the artwork    "Oil on canvas", "Watercolor", "Gold"
///   - dimensions    string    Size of the artwork or object    "16 x 20 in. (40.6 x 50.8 cm)"
///   - dimensionsParsed    float    Size of the artwork or object in centimeters, parsed    [{"element":"Sheet","dimensionType":"Height","dimension":51},{"element":"Plate","dimensionType":"Height","dimension":47.5},{"element":"Sheet","dimensionType":"Width","dimension":72.8},{"element":"Plate","dimensionType":"Width","dimension":62.5}]
///   - measurements    array    Array of elements, each with a name, description, and set of measurements. Spatial measurements are in centimeters; weights are in kg.    [ { "elementName": "Overall", "elementDescription": "Temple proper", "elementMeasurements": { "Height": 640.0813, "Length": 1249.6825, "Width": 640.0813 } } ]
///   - creditLine    string    Text acknowledging the source or origin of the artwork and the year the object was acquired by the museum.    "Robert Lehman Collection, 1975"
///   - geographyType    string    Qualifying information that describes the relationship of the place catalogued in the geography fields to the object that is being catalogued    "Made in", "From", "Attributed to"
///   - city    string    City where the artwork was created    "New York", "Paris", "Tokyo"
///   - state    string    State or province where the artwork was created, may sometimes overlap with County    "Alamance", "Derbyshire", "Brooklyn"
///   - county    string    County where the artwork was created, may sometimes overlap with State    "Orange County", "Staffordshire", "Brooklyn"
///   - country    string    Country where the artwork was created or found    "China", "France", "India"
///   - region    string    Geographic location more specific than country, but more specific than subregion, where the artwork was created or found (frequently null)    "Bohemia", "Midwest", "Southern"
///   - subregion    string    Geographic location more specific than Region, but less specific than Locale, where the artwork was created or found (frequently null)    "Malqata", "Deir el-Bahri", "Valley of the Kings"
///   - locale    string    Geographic location more specific than subregion, but more specific than locus, where the artwork was found (frequently null)    "Tomb of Perneb", "Temple of Hatshepsut", "Palace of Ramesses II"
///   - locus    string    Geographic location that is less specific than locale, but more specific than excavation, where the artwork was found (frequently null)    "1st chamber W. wall"; "Burial C 2, In coffin"; "Pit 477"
///   - excavation    string    The name of an excavation. The excavation field usually includes dates of excavation.    "MMA excavations, 1923–24"; "Khashaba excavations, 1910–11"; "Carnarvon excavations, 1912"
///   - river    string    River is a natural watercourse, usually freshwater, flowing toward an ocean, a lake, a sea or another river related to the origins of an artwork (frequently null)    "Mississippi River", "Nile River", "River Thames"
///   - classification    string    General term describing the artwork type.    "Basketry", "Ceramics", "Paintings"
///   - rightsAndReproduction    string    Credit line for artworks still under copyright.    "© 2018 Estate of Pablo Picasso / Artists Rights Society (ARS), New York"
///   - linkResource    string    URL to object's page on metmuseum.org    "https://www.metmuseum.org/art/collection/search/547802"
///   - metadataDate    datetime    Date metadata was last updated    2018-10-17T10:24:43.197Z
///   - repository    string        "Metropolitan Museum of Art, New York, NY"
///   - objectURL    string    URL to object's page on metmuseum.org    "https://www.metmuseum.org/art/collection/search/547802"
///   - tags    array    An array of subject keyword tags associated with the object and their respective AAT URL    [{"term": "Abstraction","AAT_URL": "http://vocab.getty.edu/page/aat/300056508","Wikidata_URL": "https://www.wikidata.org/wiki/Q162150"}]
///   - objectWikidata_URL    string    Wikidata URL for the object    "https://www.wikidata.org/wiki/Q432253"
///   - isTimelineWork    boolean    Whether the object is on the Timeline of Art History website    true
///   - GalleryNumber    string    Gallery number, where available    "131"
public struct ServerObjectModelRes: ServerModelTypeRes {
    let objectID: Int
    let isHighlight: Bool
    let accessionNumber: String
    let accessionYear: String
    let isPublicDomain: Bool
    let primaryImage: String
    let primaryImageSmall: String
    let additionalImages: [String]
    let constituents: [ConstituentModel]?
    let department: String
    let objectName: String
    let title: String
    let culture: String
    let period: String
    let dynasty: String
    let reign: String
    let portfolio: String
    let artistRole: String
    let artistPrefix: String
    let artistDisplayName: String
    let artistDisplayBio: String
    let artistSuffix: String
    let artistAlphaSort: String
    let artistNationality: String
    let artistBeginDate: String
    let artistEndDate: String
    let artistGender: String
    let artistWikidata_URL: String
    let artistULAN_URL: String
    let objectDate: String
    let objectBeginDate: Int
    let objectEndDate: Int
    let medium: String
    let dimensions: String
    let dimensionsParsed: [DimensionsParsedModel]?
    let measurements: [MeasurementModel]?
    let creditLine: String
    let geographyType: String
    let city: String
    let state: String
    let county: String
    let country: String
    let region: String
    let subregion: String
    let locale: String
    let locus: String
    let excavation: String
    let river: String
    let classification: String
    let rightsAndReproduction: String
    let linkResource: String
    let metadataDate: String
    let repository: String
    let objectURL: String
    let tags: [TagModel]?
    let objectWikidata_URL: String
    let isTimelineWork: Bool
    let GalleryNumber: String
}

extension ServerObjectModelRes {
    public struct ConstituentModel: Codable {
        let constituentID: Int
        let role: String
        let name: String
        let constituentULAN_URL: String
        let constituentWikidata_URL: String
        let gender: String
    }

    public struct DimensionsParsedModel: Codable {
        let element: String
        let dimensionType: String
        let dimension: Double
    }

    public struct MeasurementModel: Codable {
        let elementName: String
        let elementDescription: String?
        let elementMeasurements: ElementMeasurementModel

        public struct ElementMeasurementModel: Codable {
            let Height: Double?
            let Width: Double?
            let Diameter: Double?
        }
    }

    public struct TagModel: Codable {
        let term: String
        let AAT_URL: String
        let Wikidata_URL: String
    }
}

/*
 {
     "objectID":5,
     "isHighlight":false,
     "accessionNumber":"67.265.11",
     "accessionYear":"1967",
     "isPublicDomain":false,
     "primaryImage":"",
     "primaryImageSmall":"",
     "additionalImages":[

     ],
     "constituents":null,
     "department":"The American Wing",
     "objectName":"Coin",
     "title":"Two-and-a-Half Dollar Coin",
     "culture":"",
     "period":"",
     "dynasty":"",
     "reign":"",
     "portfolio":"",
     "artistRole":"",
     "artistPrefix":"",
     "artistDisplayName":"",
     "artistDisplayBio":"",
     "artistSuffix":"",
     "artistAlphaSort":"",
     "artistNationality":"",
     "artistBeginDate":"",
     "artistEndDate":"",
     "artistGender":"",
     "artistWikidata_URL":"",
     "artistULAN_URL":"",
     "objectDate":"1909–27",
     "objectBeginDate":1909,
     "objectEndDate":1927,
     "medium":"Gold",
     "dimensions":"Diam. 11/16 in. (1.7 cm)",
     "measurements":[
         {
             "elementName":"Other",
             "elementDescription":"Object diameter",
             "elementMeasurements":{
                 "Diameter":1.7463
             }
         }
     ],
     "creditLine":"Gift of C. Ruxton Love Jr., 1967",
     "geographyType":"",
     "city":"",
     "state":"",
     "county":"",
     "country":"",
     "region":"",
     "subregion":"",
     "locale":"",
     "locus":"",
     "excavation":"",
     "river":"",
     "classification":"",
     "rightsAndReproduction":"",
     "linkResource":"",
     "metadataDate":"2021-04-06T04:41:04.967Z",
     "repository":"Metropolitan Museum of Art, New York, NY",
     "objectURL":"https://www.metmuseum.org/art/collection/search/5",
     "tags":null,
     "objectWikidata_URL":"",
     "isTimelineWork":false,
     "GalleryNumber":""
 }
 */
