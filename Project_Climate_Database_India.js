 Project    : Climate Database for India
 Lesson     : 14
 Variable   : Monthly TerraClimate Extraction Engine
 Dataset    : IDAHO_EPSCOR/TERRACLIMATE
 Period     : January 2011 – December 2021
 Resolution : ~4.6 km
 Output     : District-level Monthly Climate Database
 Author     : Muhammad Jahangir Alam
**********************************************************************/

//=====================================================================
// 1. USER SETTINGS
//=====================================================================

// -------- Select Variable --------
// pr   = Precipitation (mm)
// tmmx = Maximum Temperature (°C ×10)
// tmmn = Minimum Temperature (°C ×10)
// aet  = Actual Evapotranspiration
// pet  = Potential Evapotranspiration
// soil = Soil Moisture
// ro   = Runoff
// vpd  = Vapor Pressure Deficit
// def  = Climate Water Deficit
// srad = Solar Radiation
// ws   = Wind Speed

var climateBand = 'tmmx';
var outputName  = 'Tmax';

// Study period
var startYear = 2011;
var endYear   = 2021;

// Export name
var exportName =
'India_District_' +
outputName +
'_' +
startYear +
'_' +
endYear;


//=====================================================================
// 2. LOAD DISTRICT BOUNDARY
//=====================================================================

var districts =
ee.FeatureCollection(
'projects/hydroclimatic-stress/assets/India_Districts_742'
);

Map.setCenter(78.9629,22.5937,5);


//=====================================================================
// 3. ADD PERMANENT DISTRICT ATTRIBUTES
//=====================================================================

districts = districts.map(function(feature){

var centroid =
feature.geometry().centroid();

var lon =
centroid.coordinates().get(0);

var lat =
centroid.coordinates().get(1);

var area =
feature.geometry()
.area()
.divide(1000000);

var state =
ee.String(feature.get('STATE'));

var district =
ee.String(feature.get('District'));

var stateDistrict =
state.cat('_').cat(district);

return feature.set({

Latitude : lat,

Longitude : lon,

Area_km2 : area,

State_District : stateDistrict

});

});


//=====================================================================
// 4. LOAD TERRACLIMATE
//=====================================================================

var climate =
ee.ImageCollection(
'IDAHO_EPSCOR/TERRACLIMATE'
)
.filterDate(
startYear + '-01-01',
(endYear + 1) + '-01-01'
);

print('TerraClimate Collection', climate);


//=====================================================================
// 5. INSPECT DATASET
//=====================================================================

var firstImage =
ee.Image(climate.first());

print('First Image', firstImage);

print('Available Bands',
firstImage.bandNames());


//=====================================================================
// 6. DISPLAY SAMPLE IMAGE
//=====================================================================

var sampleImage =
climate
.filterDate('2011-01-01','2011-02-01')
.first()
.select(climateBand);

Map.addLayer(
sampleImage,
{
min:0,
max:400,
palette:[
'white',
'cyan',
'blue',
'darkblue'
]
},
'Sample Image'
);


//=====================================================================
// 7. MONTHLY EXTRACTION FUNCTION
//=====================================================================

function extractMonthly(year,month){

var start =
ee.Date.fromYMD(year,month,1);

var end =
start.advance(1,'month');

var image =
climate
.filterDate(start,end)
.first()
.select(climateBand);

var table =
image.reduceRegions({

collection:districts,

reducer:ee.Reducer.mean(),

scale:4638

});

table =
table.map(function(feature){

return ee.Feature(null,{

ID :
feature.get('ID'),

District :
feature.get('District'),

STATE :
feature.get('STATE'),

State_District :
feature.get('State_District'),

Latitude :
feature.get('Latitude'),

Longitude :
feature.get('Longitude'),

Area_km2 :
feature.get('Area_km2'),

Year :
year,

Month :
month,

Value :
feature.get('mean')

});

});

return table;

}


//=====================================================================
// 8. TEST
//=====================================================================

var test =
extractMonthly(2011,1);

print('Sample Records');

print(test.limit(5));


//=====================================================================
// 9. BUILD DATABASE
//=====================================================================

var database =
ee.FeatureCollection([]);

for(var year=startYear;
    year<=endYear;
    year++){

for(var month=1;
    month<=12;
    month++){

print(year,month);

var oneMonth =
extractMonthly(year,month);

database =
database.merge(oneMonth);

}

}


//=====================================================================
// 10. EXPORT
//=====================================================================

Export.table.toDrive({

collection:
database,

description:
exportName,

folder:
'GEE_Output',

fileNamePrefix:
exportName,

fileFormat:
'CSV'

});


//=====================================================================
// END
//=====================================================================