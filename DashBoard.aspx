<%@ Page Title="Monitor | Home" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="DashBoard.aspx.cs" Inherits="BizTalk_Monitor.DashBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link rel="stylesheet" type="text/css" href="Styles/jquery.datetimepicker.css" />
<script type = "text/javascript" src="Scripts/jquery.js"></script>
<script type = "text/javascript" src="Scripts/jquery.datetimepicker.js"></script>
<script type="text/javascript">
    var jQuery_date = $.noConflict(true);
</script>
<link type="text/css" href="Styles/ui-lightness/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
    var jQuery_1_8_3 = $.noConflict(true);
</script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
<script type="text/javascript" src="MultiSelect/jquery.multiple.select.js"></script>
<link href="MultiSelect/multiple-select.css" rel="stylesheet" />
<script type="text/javascript">
    var jQuery_multiselect = $.noConflict(true);
</script>
<style type="text/css">
.rightborder
{
    border:2px solid Gray;
    text-align:center;
    vertical-align:middle;
    
}
.aTag
{
text-decoration: none;
height: 30px;
font-size: small;
color: #3399FF; 
text-align: right;
}
.textAlign
{
text-align:center;
vertical-align:middle;
}
.staticRightborder
{
    border: 2px white;
    border-style: solid;
    border-spacing:none;
    text-align:center;
    vertical-align:middle;
}
.topDIVBorder
{
    border: 2px white;
    border-style: solid;
    border-top-color:#E8E8E8;
    
}
.ButtonClass
{
cursor: pointer;
}

.drpField
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 100%;
}
.drpOperator
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 100%;
}
.drpValue
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.drpValueApp
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.drpValueHost
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.drpValueGroup
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.drpValueMachine
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.txtValue
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 22px; 
width: 78%;
}
</style>
<link type="text/css" href="Styles/ui-lightness/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" language="javascript">
var optionArray = ["Event Log", "Event Level", "Event Timestamp", "Event Source", "Machine"];
var arrayOperator = ["Greater Than or Equals", "Less Than or Equals", "Between Dates"];
var sID = 0;
var previousValue = [];
var eventLevel = ["Error", "Information", "Warning"];
var conditionArray = ["N", "N", "N", "N", "N"];
//multiple values will be CSV
var conditionValueArray = ["", "", "", "", "" ];
var conditionOperatorArray = ["=", "=", ">=", "=", "="];

function AddFilter() {
if (optionArray.length > 0) {
var ddlmain = document.getElementById("<%= drpMatchCondition.ClientID %>");
var newDropDown1 = document.createElement("select");
var newDropDown2 = document.createElement("select");
var aTag = document.createElement("a");
var txt = document.createTextNode(" Remove")

var _select_id = "drpField" + sID;
var _select_aid = "aTag" + sID;
var _ddl_no = sID;
var _select_id2 = "drpOperator" + sID;

newDropDown1.setAttribute("id", _select_id);
newDropDown2.setAttribute("id", _select_id2);
aTag.setAttribute("id", _select_aid);
newDropDown1.setAttribute("class", "drpField");
newDropDown2.setAttribute("class", "drpOperator");

aTag.setAttribute("class", "aTag");
aTag.appendChild(txt);

var table = document.getElementById("tblFilter");
var row = table.insertRow(table.rows.length);
var cell1 = row.insertCell(0);
cell1.setAttribute("id", "cell1" + (sID + 1));
cell1.appendChild(newDropDown1);
var cell2 = row.insertCell(1);
cell2.setAttribute("id", "cell2" + (sID + 1));
cell2.appendChild(newDropDown2);

var cell3 = row.insertCell(2);
cell3.setAttribute("id", "cell3" + (sID + 1));

PopulateDropDownList(_select_id, 1, _ddl_no, cell3);
PopulateDropDownList(_select_id2, 2, _ddl_no, cell3);

cell3.appendChild(aTag);

optionArray.reverse();
optionArray.pop();
optionArray.reverse();

newDropDown1.selectedIndex = 0;
newDropDown2.selectedIndex = 0;

newDropDown1.onchange = function () { ToggleArray(_select_id); };
aTag.setAttribute("href", "#");
newDropDown2.onchange = function () { UpdateOperator(_select_id2); };

sID = sID + 1;
}
}

function AddDDLBoxRemoveTextBox(previousvalue, currentVal, dropdownID) {
if (previousvalue == "Event Timestamp") {
HandleDDLBoxOnToggle(dropdownID, currentVal);
}
else {
var par = jQuery_1_8_3("#" + "drpValue" + dropdownID).parent();
jQuery_1_8_3("#" + "drpValue" + dropdownID).remove();
jQuery_1_8_3("#" + "aTag" + dropdownID).remove();
var cellNo = document.getElementById(par[0].id);

switch (previousvalue) {
case "Event Log":
jQuery_1_8_3('.drpValueApp').remove();
break;
case "Event Level":
jQuery_1_8_3('.drpValueHost').remove();
break;
case "Event Source":
jQuery_1_8_3('.drpValueGroup').remove();
break;
case "Machine":
jQuery_1_8_3('.drpValueMachine').remove();
break;
}

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + dropdownID;
newDropDown3.setAttribute("id", _select_id3);

switch (currentVal) {
case "Event Log":
newDropDown3.setAttribute("multiple", "single");
newDropDown3.setAttribute("class", "drpValueApp");
break;
case "Event Level":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueHost");
break;
case "Event Source":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
break;
case "Machine":
newDropDown3.setAttribute("multiple", "single");
newDropDown3.setAttribute("class", "drpValueMachine");
break;
}

var txt = document.createTextNode(" Remove")
var aTag = document.createElement("a");
var _select_aid = "aTag" + dropdownID;

aTag.setAttribute("id", _select_aid);
aTag.setAttribute("class", "aTag");
aTag.appendChild(txt);
aTag.setAttribute("href", "#");

cellNo.appendChild(newDropDown3);
cellNo.appendChild(aTag);

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
switch (currentVal) {
case "Event Log":
var appNames = document.getElementById("<%= hdnEventLog.ClientID %>").value.split(";");
PopulateDDList(dropdownID, appNames);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[0] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Event Log"
});
break;
case "Event Level":
var hostNames = document.getElementById("<%= hdnEventLevel.ClientID %>").value.split(";");
PopulateDDList(dropdownID, hostNames);

var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[1] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Event Type",
selectAllText: "Select All Types",
allSelected: "All Events Selected"
});
break;
case "Event Source":
var sourceNames = document.getElementById("<%= hdnEventSource.ClientID %>").value.split(";");
PopulateDDList(dropdownID, sourceNames);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
orderedGroup = fieldName;
conditionValueArray[3] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Event Source",
selectAllText: "Select All Sources",
allSelected: "All Sources Selected"
});
break;
case "Machine":
var computerNames = document.getElementById("<%= hdnEventSource.ClientID %>").value.split(";");
PopulateDDList(dropdownID, computerNames);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[4] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Computer"
});
break;
}
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
}

function PopulateDDList(ddlID, arrayName) {
for (var arrayCount = 0; arrayCount < arrayName.length; arrayCount++) {
var optarray = document.createElement("option");
optarray.value = arrayName[arrayCount];
optarray.text = arrayName[arrayCount];
document.getElementById("drpValue" + ddlID).options.add(optarray);
document.getElementById("drpValue" + ddlID).selectedIndex = 0;
}
}

function AddTextBoxRemoveDDLBox(previousvalue, currentVal, dropdownID) {
if (previousvalue == "Event Log" || previousvalue == "Event Level" || previousvalue == "Event Source" || previousvalue == "Machine") {
HandleTextBoxOnToggle(dropdownID, currentVal, 0, previousvalue);
}
}

function HandleTextBoxOnToggle(dropDownNo, currentFieldValue, textStatus, previousFieldValue) {
var par;
if (textStatus == 0) {
par = jQuery_1_8_3("#" + "drpValue" + dropDownNo).parent();
jQuery_1_8_3("#" + "drpValue" + dropDownNo).remove();
jQuery_1_8_3("#" + "aTag" + dropDownNo).remove();

switch (previousFieldValue) {
case "Event Log":
jQuery_1_8_3('.drpValueApp').remove();
break;
case "Event Level":
jQuery_1_8_3('.drpValueHost').remove();
break;
case "Event Source":
jQuery_1_8_3('.drpValueGroup').remove();
break;
case "Machine":
jQuery_1_8_3('.drpValueMachine').remove();
break;
}
}

var cellNo = document.getElementById(par[0].id);

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + dropDownNo;
var txt = document.createTextNode(" Remove")
var aTag = document.createElement("a");
var _select_aid = "aTag" + dropDownNo;

aTag.setAttribute("id", _select_aid);
aTag.setAttribute("class", "aTag");

newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
aTag.appendChild(txt);
aTag.setAttribute("href", "#");

cellNo.appendChild(newTextBox);
cellNo.appendChild(aTag);

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };

if (currentFieldValue == "Event Timestamp") {
jQuery_date(function () {
jQuery_date("#txtValue" + dropDownNo).datetimepicker();
});
}
}

function ReToggleAllDropDownlist(dropDownNo, currentValue) {
for (var k = 0; k < sID; k++) {
var ddl = document.getElementById("drpField" + k);
if (ddl != null && k != dropDownNo) {
for (i = 0; i < ddl.length; i++) {
if (ddl.options[i].value == currentValue) {
ddl.remove(i);
break;
}
}
}
}
}

function HandleDDLBoxOnToggle(dropDownNo, currentSelectedvalue) {
var par = jQuery_1_8_3("#" + "txtValue" + dropDownNo).parent();
var cellNo = document.getElementById(par[0].id);

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + dropDownNo;
newDropDown3.setAttribute("id", _select_id3);

switch (currentSelectedvalue) {
case "Event Log":
newDropDown3.setAttribute("multiple", "single");
newDropDown3.setAttribute("class", "drpValueApp");
break;
case "Event Level":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueHost");
break;
case "Event Source":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
break;
case "Machine":
newDropDown3.setAttribute("multiple", "single");
newDropDown3.setAttribute("class", "drpValueMachine");
break;
}
   
var txt = document.createTextNode(" Remove")
var aTag = document.createElement("a");
var _select_aid = "aTag" + dropDownNo;

aTag.setAttribute("id", _select_aid);
aTag.setAttribute("class", "aTag");
aTag.appendChild(txt);
aTag.setAttribute("href", "#");

jQuery_1_8_3("#" + "txtValue" + dropDownNo).remove();
jQuery_1_8_3("#" + "aTag" + dropDownNo).remove();

cellNo.appendChild(newDropDown3);
cellNo.appendChild(aTag);

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}

function PopulateDropDownList(dropDownID, dropdownType, currentDropDownID, cellID) {
if (dropdownType == 1) {
var dropDownNo = dropDownID.substring(8);
for (var i = 0; i < optionArray.length; i++) {
var opt = document.createElement("option");
opt.value = optionArray[i];
opt.text = optionArray[i];
document.getElementById(dropDownID).options.add(opt);
}
document.getElementById(dropDownID).selectedIndex = 0;

if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Event Log") {
var appNames = document.getElementById("<%= hdnEventLog.ClientID %>").value.split(";");

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
var classID = "App" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValueApp");
//newDropDown3.setAttribute("multiple", "single");
cellID.appendChild(newDropDown3);

for (var appCount = 0; appCount < appNames.length; appCount++) {

var optapp = document.createElement("option");
optapp.value = appCount;
optapp.text = appNames[appCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optapp);
}
newDropDown3.selectedIndex = 0;
conditionArray[0] = "Y";
conditionValueArray[0] = newDropDown3[0].text;
conditionOperatorArray[0] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Event Log"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Event Level") {
var hostNames = document.getElementById("<%= hdnEventLevel.ClientID %>").value.split(";");

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueHost");
cellID.appendChild(newDropDown3);

for (var hostCount = 0; hostCount < hostNames.length; hostCount++) {
var opthost = document.createElement("option");
opthost.value = hostNames[hostCount];
opthost.text = hostNames[hostCount];
document.getElementById("drpValue" + currentDropDownID).options.add(opthost);
}

newDropDown3.selectedIndex = 0;

conditionArray[1] = "Y";
conditionValueArray[1] = newDropDown3[0].text;
conditionOperatorArray[1] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Event Type",
selectAllText: "Select All Types",
allSelected: "All Types Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Event Source") {
var eventSource = document.getElementById("<%= hdnEventSource.ClientID %>").value.split(";");
var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValueGroup");
newDropDown3.setAttribute("multiple", "multiple");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < eventSource.length; statusCount++) {
var optStatus = document.createElement("option");
optStatus.value = eventSource[statusCount];
optStatus.text = eventSource[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[3] = "Y";
conditionValueArray[3] = newDropDown3[0].text
conditionOperatorArray[3] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);

document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Event Source",
selectAllText: "Select All Sources",
allSelected: "All Sources Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Machine") {
var computerName = document.getElementById("<%= hdnComputerName.ClientID %>").value.split(";");
var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValueMachine");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < computerName.length; statusCount++) {
var optStatus = document.createElement("option");
optStatus.value = computerName[statusCount];
optStatus.text = computerName[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[4] = "Y";
conditionValueArray[4] = "";
conditionOperatorArray[4] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Computer"
});

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Event Timestamp") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);

conditionArray[2] = "Y";
conditionOperatorArray[2] = ">=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_date(function () {
jQuery_date("#txtValue" + currentDropDownID).datetimepicker();
});

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };

}

previousValue[dropDownNo] = optionArray[0];
if (currentDropDownID > 0) {
RePopulateAllDropDownlist(currentDropDownID);
}

}
else if (dropdownType == 2) {
if (optionArray[0] == "Event Timestamp") {
for (var j = 0; j < 3; j++) {
var opth = document.createElement("option");
opth.value = arrayOperator[j];
opth.text = arrayOperator[j];
document.getElementById(dropDownID).options.add(opth);
}
}
else {
var opte = document.createElement("option");
opte.value = "Is equal to";
opte.text = "Is equal to";
document.getElementById(dropDownID).options.add(opte);
}
document.getElementById(dropDownID).selectedIndex = 0;
}
}

function UpdateOperator(ddlOperatorID) {
var ddlOperator = document.getElementById(ddlOperatorID);
var dropDownNo = ddlOperatorID.substring(11);
var fieldname = document.getElementById("drpField" + dropDownNo).options[document.getElementById("drpField" + dropDownNo).selectedIndex].value;
var ddlLength = ddlOperator.length;
if (ddlLength > 1) {
switch (ddlOperator.selectedIndex) {
case 0:
if (fieldname == "Creation Time") {
conditionOperatorArray[1] = ">=";
}
else {
conditionOperatorArray[9] = ">=";
}
break;
case 1:
if (fieldname == "Creation Time") {
conditionOperatorArray[1] = "<=";
}
else {
conditionOperatorArray[9] = "<=";
}
break;
}
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
}
}

function ReturnCSVArray(mainArray) {
var csvArray = "";
for (var arrayCount = 0; arrayCount < mainArray.length; arrayCount++) {
if (arrayCount == 0) {
csvArray = mainArray[arrayCount]
}
else {
csvArray = csvArray + ";" + mainArray[arrayCount];
}
}
return csvArray;
}


function ToggleTextBox(_select_id) {
var txtBox = document.getElementById(_select_id);
var txtBoxNo = _select_id.substring(8);
var currentValue = txtBox.value;

var ddlField = document.getElementById("drpField" + txtBoxNo);
var fieldName = ddlField.options[ddlField.selectedIndex].value;

switch (fieldName) {
case "Event Timestamp":
conditionValueArray[2] = currentValue;
break;
}
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

}
function ToggleValueArray(_select_id) {
var ddl = document.getElementById(_select_id);
var dropDownNo = _select_id.substring(8);
var currentValue = "";
var fieldName = "";
var ddlField = document.getElementById("drpField" + dropDownNo);

if (ddl.selectedIndex != -1) {
currentValue = ddl.options[ddl.selectedIndex].text;
}
if (ddlField.selectedIndex != -1) {
fieldName = ddlField.options[ddlField.selectedIndex].value;
}

if (ddlField.selectedIndex != -1) {
switch (fieldName) {
case "Event Log":
conditionValueArray[0] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
case "Event Level":
conditionValueArray[1] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
case "Event Source":
conditionValueArray[3] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
case "Machine":
conditionValueArray[4] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
}
}
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
}

function ToggleArray(_select_id) {
var ddl = document.getElementById(_select_id);
var dropDownNo = _select_id.substring(8);
var currentValue = ddl.options[ddl.selectedIndex].value;
var preValue = "";

ReToggleAllDropDownlist(dropDownNo, currentValue);
AddToggledItem(dropDownNo, previousValue[dropDownNo]);
preValue = previousValue[dropDownNo];

if (preValue == "Event Timestamp") {
var ddl2 = document.getElementById("drpOperator" + dropDownNo);

while (ddl2.length > 0) {
ddl2.remove(ddl2.length - 1);
}

var optnew = document.createElement("option");
optnew.value = "Is equal to";
optnew.text = "Is equal to";
ddl2.options.add(optnew);
ddl2.selectedIndex = 0;
}

if (preValue == "Event Log" || preValue == "Machine" || preValue == "Event Level" || preValue == "Event Source") {
var ddlApp = document.getElementById("drpValue" + dropDownNo);
while (ddlApp.length > 0) {
ddlApp.remove(ddlApp.length - 1);
}
}

if (currentValue == "Event Timestamp") {
var ddl2add = document.getElementById("drpOperator" + dropDownNo);
ddl2add.remove(0);

for (var j = 0; j < 3; j++) {
var opth = document.createElement("option");
opth.value = arrayOperator[j];
opth.text = arrayOperator[j];
document.getElementById("drpOperator" + dropDownNo).options.add(opth);
}

document.getElementById("drpOperator" + dropDownNo).selectedIndex = 0;
AddTextBoxRemoveDDLBox(preValue, currentValue, dropDownNo);
}

if (currentValue == "Event Log" || currentValue == "Event Level" || currentValue == "Event Source" || currentValue == "Machine") {
AddDDLBoxRemoveTextBox(preValue, currentValue, dropDownNo)
}

ResetCSVArrays(preValue, currentValue);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

ReindexMainArray(previousValue[dropDownNo]);
previousValue[dropDownNo] = currentValue;
}

function ResetCSVArrays(previousValue, currentValue) {
switch (previousValue) {
case "Event Log":
conditionArray[0] = 'N';
conditionValueArray[0] = "";
break;
case "Event Level":
conditionArray[1] = 'N';
conditionValueArray[1] = "";
break;
case "Event Timestamp":
conditionArray[2] = 'N';
conditionValueArray[2] = "";
break;
case "Event Source":
conditionArray[3] = 'N';
conditionValueArray[3] = "";
break;
case "Machine":
conditionArray[4] = 'N';
conditionValueArray[4] = "";
break;
}

switch (currentValue) {
case "Event Log":
conditionArray[0] = 'Y';
break;
case "Event Level":
conditionArray[1] = 'Y';
break;
case "Event Timestamp":
conditionArray[2] = 'Y';
break;
case "Event Source":
conditionArray[3] = 'Y';
break;
case "Machine":
conditionArray[4] = 'Y';
break;
}
}

function RePopulateAllDropDownlist(dropDownNo) {
for (var k = 0; k < dropDownNo; k++) {
var ddl = document.getElementById("drpField" + k);
if (ddl != null) {
for (i = 0; i < ddl.length; i++) {
if (ddl.options[i].value == optionArray[0]) {
ddl.remove(i);
break;
}
}
}
}
}

function RemoveAndToggle(id) {
var dropDownNo = id.substring(4);
var fieldValue = document.getElementById("drpField" + dropDownNo).value;

AddToggledItem(dropDownNo, previousValue[dropDownNo]);
optionArray.push(previousValue[dropDownNo]);

switch (fieldValue) {
case "Event Log":
conditionArray[0] = 'N';
conditionValueArray[0] = "";
break;
case "Event Level":
conditionArray[1] = 'N';
conditionValueArray[1] = "";
break;
case "Event Source":
conditionArray[3] = 'N';
conditionValueArray[3] = "";
orderedGroup = "";
break;
case "Machine":
conditionArray[4] = 'N';
conditionValueArray[4] = "";
break;
}
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
}



function ReindexMainArray(previousValue) {
var newArray = [];
for (var k = 0; k < sID; k++) {
var ddlist = document.getElementById("drpField" + k);
if (ddlist != null) {
newArray[k] = ddlist.options[ddlist.selectedIndex].value;
}
}
for (var newCount = 0; newCount < newArray.length; newCount++) {
for (var count = 0; count < optionArray.length; count++) {
if (newArray[newCount] == optionArray[count]) {
optionArray[count] = previousValue;
break;
}
}
}
}

function AddToggledItem(dropDownNo, previousValue) {
for (var k = 0; k < sID; k++) {
var ddl = document.getElementById("drpField" + k);
if (ddl != null && k != dropDownNo) {
var opth = document.createElement("option");
opth.value = previousValue;
opth.text = previousValue;
document.getElementById("drpField" + k).options.add(opth)
}
}
}
</script>
<script type="text/javascript">
function jScript() {
jQuery_1_8_3(document).ready(function () {
jQuery_1_8_3('#a').width(1);
jQuery_1_8_3('#a').removeClass('topDIVBorder');
jQuery_1_8_3('#a').width(jQuery_1_8_3('#dvScreenWidth').width());
jQuery_1_8_3('#a').addClass('topDIVBorder');
});
}

jQuery_1_8_3(document).ready(function () {
jQuery_1_8_3('#a').width(jQuery_1_8_3('#dvScreenWidth').width());
jQuery_1_8_3('#a').addClass('topDIVBorder');
});
jQuery_1_8_3('.aTag').live('click', function () {
RemoveAndToggle(this.id);
jQuery_1_8_3(this).parent().parent().remove();

});

function UpdateCount() {
var ddlcount = document.getElementById("<%= drpMaxmatch.ClientID %>");
document.getElementById("<%= hdnCount.ClientID %>").value = ddlcount.options[ddlcount.selectedIndex].value;
}

function UpdateMatch() {
    var ddlcount = document.getElementById("<%= drpMatchCondition.ClientID %>");
    document.getElementById("<%= hdnMatch.ClientID %>").value = ddlcount.options[ddlcount.selectedIndex].value;
}

function toggle2(showHideDiv, switchTextDiv, switchFilter) {

var ele = document.getElementById(showHideDiv);
var ele1 = document.getElementById(switchFilter);
var text = document.getElementById(switchTextDiv);

if (ele.style.display == "block") {
ele.style.display = "none";
ele1.style.display = "none";
text.innerHTML = "Show Query Expression";
}
else {
ele.style.display = "block";
ele1.style.display = "block";
text.innerHTML = "Query Expression";
}
}

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div id="dvScreenWidth" visible="false"></div>
<asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"/>
<table style="height:100%;width:100%;">
<tr>
<td style="height:15px;"></td>
</tr>
<tr>
<td>
<div>
<asp:UpdatePanel ID="UpdatePanel" runat="server">
<Triggers>
<asp:AsyncPostBackTrigger ControlID="Menu1" />                
</Triggers>
<ContentTemplate>
<script type="text/javascript" language="javascript">
    Sys.Application.add_load(jScript);
</script>                           
<asp:Menu ID="Menu1" Orientation="Horizontal" runat="server" 
        onmenuitemclick="Menu1_MenuItemClick" BorderStyle="None" Font-Size="Medium" 
        ForeColor="Gray" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="6px" 
        Height="30px" Font-Size="Medium" Width="90px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Medium" BorderStyle="None" CssClass="textAlign" Width="90px" />
<Items>
<asp:MenuItem  Text="DASH BOARD" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="ALERTS" Value="1"></asp:MenuItem>      
<asp:MenuItem Text="EVENT VIEWER" Value="2"></asp:MenuItem>   
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="8px" Font-Size="Medium" 
        Height="30px" Width="130px" BackColor="White" ForeColor="Gray" 
        CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Medium" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="130px" 
        ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" 
        Font-Size="Medium" />
</asp:Menu>
<div id="a">
<asp:MultiView ID="MultiView1" ActiveViewIndex="0" runat="server">
<asp:View ID="View1" runat="server">
<table style="width:100%">
<tr>
<td colspan="2" style="width:10px;"></td>
</tr>
<tr>
<td colspan="2" style="width:10px;">
<asp:Label ID ="lblUesrInfoText" runat="server" Font-Size="Large"></asp:Label>
</td>
</tr>
<tr>
<td>
<table style="width:45%">
<tr style="background-color:#EFF3FB">
<td style="width:40%"><asp:Label ID="Label2" runat="server" Text="<pre><b> Database</b></pre>" 
        Font-Size="Medium" ForeColor="Black"  /></td>
<td align="left"><asp:Label ID="lblDatabase" runat="server" /></td>
</tr>
<tr style="background-color:white">
<td><asp:Label ID="Label3" runat="server" Text="<pre><b> BizTalk Servers</b></pre>" 
        Font-Size="Medium" ForeColor="Black"  /></td>
<td align="left"><asp:Label ID="lblBTServers" runat="server" /></td>
</tr>
<tr style="background-color:#EFF3FB">
<td><asp:Label ID="Label4" runat="server" Text="<pre><b> Database Servers</b></pre>" 
        Font-Size="Medium" ForeColor="Black"  /></td>
<td align="left"><asp:Label ID="lblDBServers" runat="server" /></td>
</tr>
<tr style="background-color:white">
<td><asp:Label ID="Label5" runat="server" Text="<pre><b> BizTalk DR Servers</b></pre>" 
        Font-Size="Medium" ForeColor="Black"  /></td>
<td align="left"><asp:Label ID="lblBTDRServers" runat="server" /></td>
</tr>
<tr style="background-color:#EFF3FB">
<td><asp:Label ID="Label6" runat="server" Text="<pre><b> DR Database Servers</b></pre>" 
        Font-Size="Medium" ForeColor="Black"  /></td>
<td align="left"><asp:Label ID="lblDBDRServers" runat="server" /></td>
</tr>
</table>
</td>
</tr>
</table> 
</asp:View>
<asp:View ID="View2" runat="server">
<asp:UpdatePanel ID="UpdatePanelView2" runat="server">
<Triggers>               
</Triggers>
<ContentTemplate>
<script type="text/javascript" language="javascript">
    Sys.Application.add_load(jScript);
</script> 
<asp:Label ID ="lblServerInfoText" Text="<pre><b>  Section Under Construction</b></pre>" runat="server"></asp:Label>
</ContentTemplate>
</asp:UpdatePanel> 
</asp:View>   
<asp:View ID="View3" runat="server">
<table style="height:100%;width:100%;">
<tr>
<td>
<div style="padding: 5px; width:100%;">
<a id="divHeader" class="no-line" href="javascript:toggle2('divMain','divHeader','divFilter');"           
style="border-style: none; font-size: large; color: #006699; font-weight: bold;" >
Query Expression </a>
</div>
</td>
</tr>
<tr>
<td>
<div id="divMain" style="display: block;padding: 5px; width:100%;">
<asp:HiddenField id="hdnCount" runat="server" Value="10" />
<asp:HiddenField id="hdnMatch" runat="server" Value="1" />
<asp:HiddenField id="hdnEventLog" runat="server" />
<asp:HiddenField id="hdnEventLevel" runat="server" />
<asp:HiddenField id="hdnEventSource" runat="server" />
<asp:HiddenField id="hdnComputerName" runat="server" />
<asp:HiddenField id="hdnConditions" runat="server" Value ="N;N;N;N;N"/>
<asp:HiddenField id="hdnOperator" runat="server" value="=;=;=;>=;="/>
<asp:HiddenField id="hdnValues" runat="server" Value=" ; ; ; ; " />
<table style="height:100%;width:100%;">
<tr>
<td style="font-size: small;width:15%; color: #3399FF; text-align: left;">Maximum Records</td>
<td style="font-size: small; width: 15%; color: #3399FF; text-align: left;">
<asp:DropDownList ID="drpMaxmatch" runat="server" Width="100%"  Height="25px" 
Font-Bold="False" Font-Names="Arial Unicode MS" Font-Size="Small" 
ForeColor="#999999" onchange="UpdateCount()">
<asp:ListItem>10</asp:ListItem>
<asp:ListItem>25</asp:ListItem>
<asp:ListItem>50</asp:ListItem>
<asp:ListItem>100</asp:ListItem>
</asp:DropDownList>
</td>
<td style="font-size: small;width:70%; color: #3399FF; text-align: left;">
<asp:UpdatePanel ID="UpdatePanelCmd" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
<ContentTemplate>
<asp:Button ID="btnExecuteQuery" runat="server" Text="Run Query" BorderStyle="None" Width="120px" Height="25px" Font-Bold="False" Font-Size="Small" BackColor="#F88017" 
onclick="btnExecuteQuery_Click" CssClass="ButtonClass" ForeColor="White"/>
</ContentTemplate>
<Triggers>
<asp:AsyncPostBackTrigger ControlID="btnExecuteQuery" EventName="Click" />
</Triggers>
</asp:UpdatePanel>
</td>
</tr>
<tr>
<td style="font-size: small;width:15%; color: #3399FF; text-align: left;">Matching Condition</td>
<td style="font-size: small; width: 15%; color: #3399FF; text-align: left;">
<asp:DropDownList ID="drpMatchCondition" runat="server" Width="100%"  Height="25px" 
Font-Bold="False" Font-Names="Arial Unicode MS" Font-Size="Small" 
ForeColor="#999999" onchange="UpdateMatch()">
<asp:ListItem Value="1" Selected="True">ALL</asp:ListItem>
<asp:ListItem Value="0">ANY</asp:ListItem>
</asp:DropDownList>
</td>
<td style="font-size: small;width:70%; color: #3399FF; text-align: left;vertical-align:bottom;"> of the following </td>
</tr>
</table>
<table id="tblFilter" style="height:100%;width:100%;">
<tr>
<td style="font-size: small;width:20%; color: #3399FF; text-align: left;"></td>
<td style="font-size: small; width: 15%; color: #3399FF; text-align: left;"></td>
<td style="font-size: small;width:35%; color: #3399FF; text-align: left;"></td>
<td style="font-size: small;width:30%; color: #3399FF; text-align: left;"></td>
</tr>
</table>
</div>
<div id="divFilter" style="display: block;padding: 5px; width:100%;">
<a id="aFilter" class="no-line" href="#" onclick="AddFilter()" 
style="border-style: none; font-size: large; color: #006699; font-weight: bold;">Add a Filter</a>
</div>
</td>
</tr>
<tr>
<td colspan="3">
<asp:UpdatePanel ID="UpdatePanelView3" runat="server">
<Triggers>
<asp:AsyncPostBackTrigger ControlID="btnExecuteQuery" EventName="Click" />
</Triggers>
<ContentTemplate>
<script type="text/javascript" language="javascript">
    Sys.Application.add_load(jScript);
</script> 
<%--<asp:Label ID ="lblAlertInfoText" Text="<pre><b>  Section Under Construction</b></pre>" runat="server"></asp:Label>--%>
<div id="divB">
<asp:GridView ID="gridEventViewer" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8" HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" 
Visible="False" DataKeyNames="Instance ID"                     
OnRowCommand="gridEventViewer_RowCommand"
OnRowDataBound = "gridEventViewer_RowDataBound" >
<Columns>
<asp:TemplateField HeaderText="View" SortExpression="">
<ItemTemplate>
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View Instance Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("Instance ID") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
</Columns>
<AlternatingRowStyle BackColor="White" Wrap="False" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<EmptyDataRowStyle Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
<asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
</div>
</ContentTemplate>
</asp:UpdatePanel> 
</td>
</tr>
</table>
</asp:View>   
<asp:View ID="View4" runat="server">
<%--<asp:Label ID ="Label1" Text="<pre><b>  Section Under Construction</b></pre>" runat="server"></asp:Label>--%>
</asp:View>  
</asp:MultiView>
</div>     
</ContentTemplate>
</asp:UpdatePanel> 
</div>
</td>
</tr>
</table>
</asp:Content>
