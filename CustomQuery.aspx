<%@ Page EnableEventValidation="false" Title="Monitor | Custom Queries" MaintainScrollPositionOnPostback="true" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="CustomQuery.aspx.cs" Inherits="BizTalk_Monitor.CustomQuery" %>
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
<script type="text/javascript" language="javascript">
var array1 = ["Application Name", "Creation Time", "Group Results By", "Host Name", "Instance Status", "Service Instance ID"];
var array2 = ["Application Name", "Creation Time", "Group Results By", "Host Name", "Instance Status", "Pending Operations", "Service Instance ID"];
var array3 = ["Application Name", "Creation Time", "Error Code", "Error Description",  "Group Results By", "Host Name", "Instance Status", "Service Instance ID", "Suspension Time"];
var arrayOperator = ["Greater Than or Equals", "Less Than or Equals"];
var sID = 0;
var previousValue = [];
var previousValue2 = [];
var previousValue3 = [];
var arraySelected = 0;
var instanceStatus = ["All Runnung", "All Suspended", "Active", "Dehydrated", "Ready to Run", "Scheduled", "Suspended Resumable", "Suspended Non Resumable"];
var instanceStatus1 = ["Active", "Dehydrated", "Ready to Run", "Scheduled"];
var instanceStatus2 = ["Suspended Resumable", "Suspended Non Resumable"];
var errorDescription = ["Contains"];
var grouping1 = ["Application", "Host Name", "Service Class", "Service Instance Status", "Service Name"];
var grouping2 = ["Application", "Host Name", "Service Class", "Service Instance Status", "Service Name"];
var grouping3 = ["Application", "Error Code", "Error Description", "Host Name", "Service Class", "Service Instance Status", "Service Name"];
var orderedGroup = "";

/* conditionArray mapping Y/N
0-Application Name
1-Creation Time
2-Group Results By
3-Host Name
4-Instance Status
5-Service Instance ID
6-Pending Operations
7-Error Code
8-Error Description
9-Suspension Time
*/
var conditionArray = ["N", "N", "N", "N", "N", "N", "N", "N", "N", "N"];
//multiple values will be CSV
var conditionValueArray = ["", "", "", "", "", "", "", "", "", "", ];
var conditionOperatorArray = ["=", ">=", "=", "=", "=", "=", "=", "=", "=", ">=", ];


function toggle2(showHideDiv, switchTextDiv, switchFilter) {

var ele = document.getElementById(showHideDiv);
var ele1 = document.getElementById(switchFilter);
var text = document.getElementById(switchTextDiv);
	
if(ele.style.display == "block") {
ele.style.display = "none"; 
ele1.style.display = "none";
text.innerHTML = "<img src=\"Images/Expand.jpg\" alt=\"tog\" style=\"background-color: #FFFFFF; border-style: none\" /> Show Query";
}
else {
ele.style.display = "block";
ele1.style.display = "block";
text.innerHTML = "<img src=\"Images/collapse.jpg\" alt=\"tog\" style=\"background-color: #FFFFFF; border-style: none\" /> Build Query";
}
}

function DecideArrayType() {
var ddlmain = document.getElementById("<%= drpMain.ClientID %>");
var selectedOption = ddlmain.selectedIndex;
if (selectedOption == 1) {
arraySelected = 1;
}
else if (selectedOption == 2) {
arraySelected = 2;
}
else {
arraySelected = 0;
}

DeleteAllRows();

array1 = ["Application Name", "Creation Time", "Group Results By", "Host Name", "Instance Status", "Service Instance ID"];
array2 = ["Application Name", "Creation Time", "Group Results By", "Host Name", "Instance Status", "Pending Operations", "Service Instance ID"];
array3 = ["Application Name", "Creation Time", "Error Code", "Error Description", "Group Results By", "Host Name", "Instance Status", "Service Instance ID", "Suspension Time"];
previousValue = [];
previousValue2 = [];
previousValue3 = [];
sID = 0;
orderedGroup = "";
conditionArray = ["N", "N", "N", "N", "N", "N", "N", "N", "N", "N"];
conditionValueArray = ["", "", "", "", "", "", "", "", "", "", ];
conditionOperatorArray = ["=", ">=", "=", "=", "=", "=", "=", "=", "=", ">=", ];
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnMainArray.ClientID %>").value = arraySelected;
}

function UpdateCount() {
var ddlcount = document.getElementById("<%= drpMaxmatch.ClientID %>");
document.getElementById("<%= hdnCount.ClientID %>").value = ddlcount.options[ddlcount.selectedIndex].value;
}

function DeleteAllRows() {
jQuery_1_8_3('.aTag').parent().parent().remove();
}

function AddFilter() {
if ((array1.length > 0 && arraySelected == 0) || (array2.length > 0 && arraySelected == 1) || (array3.length > 0 && arraySelected == 2)) {
var ddlmain = document.getElementById("<%= drpMain.ClientID %>");
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

PopulateDropDownList(_select_id, arraySelected + 1, 1, _ddl_no, cell3);
PopulateDropDownList(_select_id2, arraySelected + 1, 2, _ddl_no, cell3);

cell3.appendChild(aTag);

if (arraySelected == 0) {
array1.reverse();
array1.pop();
array1.reverse();
}
else if (arraySelected == 1) {
array2.reverse();
array2.pop();
array2.reverse();
}
else if (arraySelected == 2) {
array3.reverse();
array3.pop();
array3.reverse();
}

newDropDown1.selectedIndex = 0;
newDropDown2.selectedIndex = 0;

newDropDown1.onchange = function () { ToggleArray(_select_id); };
aTag.setAttribute("href", "#");
newDropDown2.onchange = function () { UpdateOperator(_select_id2); };

sID = sID + 1;
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
var csvArray="";
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

function PopulateDropDownList(dropDownID, arrayType, dropdownType, currentDropDownID, cellID) {
if (arrayType == 1) {
if (dropdownType == 1) {
var dropDownNo = dropDownID.substring(8);
for (var i = 0; i < array1.length; i++) {
var opt = document.createElement("option");
opt.value = array1[i];
opt.text = array1[i];
document.getElementById(dropDownID).options.add(opt);
}
document.getElementById(dropDownID).selectedIndex = 0;

if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Application Name") {
var appNames = document.getElementById("<%= hdnAppName.ClientID %>").value.split(";");

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
var classID = "App" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValueApp");
newDropDown3.setAttribute("multiple", "multiple");
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
placeholder: "Select Here",
selectAllText: "Select All Applications",
allSelected:"All Applications Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Host Name") {
var hostNames = document.getElementById("<%= hdnHostName.ClientID %>").value.split(";");

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

conditionArray[3] = "Y";
conditionValueArray[3] = newDropDown3[0].text;
conditionOperatorArray[3] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All Hosts",
allSelected: "All Hosts Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Instance Status") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValue");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < instanceStatus.length; statusCount++) {
var optStatus = document.createElement("option");
optStatus.value = instanceStatus[statusCount];
optStatus.text = instanceStatus[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[4] = "Y";
conditionValueArray[4] = newDropDown3[0].text
conditionOperatorArray[4] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);

document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Group Results By") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < grouping1.length; statusCount++) {
var optGroupStatus = document.createElement("option");
optGroupStatus.value = grouping1[statusCount];
optGroupStatus.text = grouping1[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optGroupStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[2] = "Y";
conditionValueArray[2] = newDropDown3[0].text;
orderedGroup = newDropDown3[0].text;
conditionOperatorArray[2] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Service Instance ID") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);

conditionArray[5] = "Y";
conditionValueArray[5] = "";
conditionOperatorArray[5] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Creation Time") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);

conditionArray[1] = "Y";
conditionOperatorArray[1] = ">=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_date(function () {
jQuery_date("#txtValue" + currentDropDownID).datetimepicker();
});

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };

}
            
previousValue[dropDownNo] = array1[0];
if (currentDropDownID > 0) {
RePopulateAllDropDownlist(currentDropDownID);
}

}
else if (dropdownType == 2) {
if (array1[0] == "Creation Time") {
for (var j = 0; j < 2; j++) {
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
else if (arrayType == 2) {
if (dropdownType == 1) {
var dropDownNo = dropDownID.substring(8);
for (var i = 0; i < array2.length; i++) {
var opt = document.createElement("option");
opt.value = array2[i];
opt.text = array2[i];
document.getElementById(dropDownID).options.add(opt);
}
document.getElementById(dropDownID).selectedIndex = 0;

if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Application Name") {
var appNames = document.getElementById("<%= hdnAppName.ClientID %>").value.split(";");

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;

newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueApp");
cellID.appendChild(newDropDown3);

for (var appCount = 0; appCount < appNames.length; appCount++) {

var optapp = document.createElement("option");
optapp.value = appNames[appCount];
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
placeholder: "Select Here",
selectAllText: "Select All Applications",
allSelected: "All Applications Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Host Name") {
var hostNames = document.getElementById("<%= hdnHostName.ClientID %>").value.split(";");

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
conditionArray[3] = "Y";
conditionValueArray[3] = newDropDown3[0].text;
conditionOperatorArray[3] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All Hosts",
allSelected: "All Hosts Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Instance Status") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValue");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < instanceStatus1.length; statusCount++) {
var optStatus = document.createElement("option");
optStatus.value = instanceStatus1[statusCount];
optStatus.text = instanceStatus1[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[4] = "Y";
conditionValueArray[4] = newDropDown3[0].text;
conditionOperatorArray[4] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Group Results By") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < grouping2.length; statusCount++) {
var optGroupStatus = document.createElement("option");
optGroupStatus.value = grouping2[statusCount];
optGroupStatus.text = grouping2[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optGroupStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[2] = "Y";
conditionValueArray[2] = newDropDown3[0].text;
orderedGroup = newDropDown3[0].text;
conditionOperatorArray[2] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Pending Operations") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("class", "drpValue");
cellID.appendChild(newDropDown3);

var pendingOp =["Suspend", "Terminate"]

for (var statusCount = 0; statusCount < pendingOp.length; statusCount++) {
var optGroupStatus = document.createElement("option");
optGroupStatus.value = pendingOp[statusCount];
optGroupStatus.text = pendingOp[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optGroupStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[6] = "Y";
conditionValueArray[6] = newDropDown3[0].text;
conditionOperatorArray[6] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Service Instance ID") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[5] = "Y";
conditionValueArray[5] = "";
conditionOperatorArray[5] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Creation Time") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);

conditionArray[1] = "Y";
conditionOperatorArray[1] = ">=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_date(function () {
jQuery_date("#txtValue" + currentDropDownID).datetimepicker();
});

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
            
previousValue2[dropDownNo] = array2[0];
if (currentDropDownID > 0) {
RePopulateAllDropDownlist(currentDropDownID);
}

}
else if (dropdownType == 2) {
if (array2[0] == "Creation Time") {
for (var j = 0; j < 2; j++) {
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
else if (arrayType == 3) {
if (dropdownType == 1) {
var dropDownNo = dropDownID.substring(8);
for (var i = 0; i < array3.length; i++) {
var opt = document.createElement("option");
opt.value = array3[i];
opt.text = array3[i];
document.getElementById(dropDownID).options.add(opt);
}
document.getElementById(dropDownID).selectedIndex = 0;

if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Application Name") {
var appNames = document.getElementById("<%= hdnAppName.ClientID %>").value.split(";");

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;

newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueApp");
cellID.appendChild(newDropDown3);

for (var appCount = 0; appCount < appNames.length; appCount++) {

var optapp = document.createElement("option");
optapp.value = appNames[appCount];
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
placeholder: "Select Here",
selectAllText: "Select All Applications",
allSelected: "All Applications Selected"
});

newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Host Name") {
var hostNames = document.getElementById("<%= hdnHostName.ClientID %>").value.split(";");

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
conditionArray[3] = "Y";
conditionValueArray[3] = newDropDown3[0].text;
conditionOperatorArray[3] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All Hosts",
allSelected: "All Hosts Selected"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Instance Status") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueSuspendedStatus");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < instanceStatus2.length; statusCount++) {
var optStatus = document.createElement("option");
optStatus.value = instanceStatus2[statusCount];
optStatus.text = instanceStatus2[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[4] = "Y";
conditionValueArray[4] = newDropDown3[0].text;
conditionOperatorArray[4] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Group Results By") {

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + currentDropDownID;
newDropDown3.setAttribute("id", _select_id3);
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
cellID.appendChild(newDropDown3);

for (var statusCount = 0; statusCount < grouping1.length; statusCount++) {
var optGroupStatus = document.createElement("option");
optGroupStatus.value = grouping3[statusCount];
optGroupStatus.text = grouping3[statusCount];
document.getElementById("drpValue" + currentDropDownID).options.add(optGroupStatus);
}

newDropDown3.selectedIndex = 0;
conditionArray[2] = "Y";
conditionValueArray[2] = newDropDown3[0].text;
orderedGroup = newDropDown3[0].text;
conditionOperatorArray[2] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_multiselect('#' + _select_id3).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Service Instance ID") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[5] = "Y";
conditionValueArray[5] = "";
conditionOperatorArray[5] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Error Code") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[7] = "Y";
conditionValueArray[7] = "";
conditionOperatorArray[7] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);


newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Error Description") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[8] = "Y";
conditionValueArray[8] = "";
conditionOperatorArray[8] = "=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Creation Time") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[1] = "Y";
conditionOperatorArray[1] = ">=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_date(function () {
jQuery_date("#txtValue" + currentDropDownID).datetimepicker();
});

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}
else if (document.getElementById(dropDownID).options[document.getElementById(dropDownID).selectedIndex].value == "Suspension Time") {

var newTextBox = document.createElement("input");
var _select_id3 = "txtValue" + currentDropDownID;
newTextBox.setAttribute("id", _select_id3);
newTextBox.setAttribute("class", "txtValue");
newTextBox.type = "text";
cellID.appendChild(newTextBox);
conditionArray[9] = "Y";
conditionOperatorArray[9] = ">=";
document.getElementById("<%= hdnOperator.ClientID %>").value = ReturnCSVArray(conditionOperatorArray);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

jQuery_date(function () {
jQuery_date("#txtValue" + currentDropDownID).datetimepicker();
});

newTextBox.onchange = function () { ToggleTextBox(_select_id3); };
}

previousValue3[dropDownNo] = array3[0];
if (currentDropDownID > 0) {
RePopulateAllDropDownlist(currentDropDownID);
}

}
else if (dropdownType == 2) {
if (array3[0] == "Creation Time" || array3[0] == "Suspension Time") {
for (var j = 0; j < 2; j++) {
var opth = document.createElement("option");
opth.value = arrayOperator[j];
opth.text = arrayOperator[j];
document.getElementById(dropDownID).options.add(opth);
}
}
else if (array3[0] == "Error Description") {
for (var j = 0; j < errorDescription.length; j++) {
var opte = document.createElement("option");
opte.value = errorDescription[j];
opte.text = errorDescription[j];
document.getElementById(dropDownID).options.add(opte);
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
}

function ToggleTextBox(_select_id) {
var txtBox = document.getElementById(_select_id);
var txtBoxNo = _select_id.substring(8);
var currentValue = txtBox.value;

var ddlField = document.getElementById("drpField" + txtBoxNo);
var fieldName = ddlField.options[ddlField.selectedIndex].value;

switch (fieldName) {
case "Creation Time":
conditionValueArray[1] = currentValue;
break;
case "Service Instance ID":
conditionValueArray[5] = currentValue;
break;
case "Error Code":
conditionValueArray[7] = currentValue;
break;
case "Error Description":
conditionValueArray[8] = currentValue;
break;
case "Suspension Time":
conditionValueArray[9] = currentValue;
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
case "Application Name":
conditionValueArray[0] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
case "Group Results By":
ReturnOrderGroupCondition(jQuery_multiselect(ddl).multipleSelect("getSelects", "text"));

conditionValueArray[2] = orderedGroup;
break;
case "Host Name":
conditionValueArray[3] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
break;
case "Instance Status":
if (arraySelected == 2) {
conditionValueArray[4] = jQuery_multiselect(ddl).multipleSelect("getSelects", "text");
}
else {
conditionValueArray[4] = currentValue;
}
break;
case "Pending Operations":
conditionValueArray[6] = currentValue;
break;
}
}
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
}

function ReturnOrderGroupCondition(getSelectedValues) {
var externArray = orderedGroup.split(",");
var tempArray = getSelectedValues;
var uniqueArray = [];

for (var external = 0; external < externArray.length; external++) {
for (var internalCount = 0; internalCount < getSelectedValues.length; internalCount++) {
if (externArray[external].trim() == getSelectedValues[internalCount].trim()) {
uniqueArray.push(externArray[external]);
tempArray[internalCount] = "";
break;
}

}
}

for (var tempCount = 0; tempCount < tempArray.length; tempCount++) {
if (tempArray[tempCount] != "") {
uniqueArray.push(tempArray[tempCount]);
}
}
orderedGroup = "";
for (var i = 0; i < uniqueArray.length; i++) {
if (i == 0) {
orderedGroup =  uniqueArray[i];
}
else {
orderedGroup = orderedGroup + "," + uniqueArray[i];
}
        
}
}

function ToggleArray(_select_id) {
var ddl = document.getElementById(_select_id);
var dropDownNo = _select_id.substring(8);
var currentValue = ddl.options[ddl.selectedIndex].value;
var preValue = "";

ReToggleAllDropDownlist(dropDownNo, currentValue);
if (arraySelected == 0) {
AddToggledItem(dropDownNo, previousValue[dropDownNo]);
preValue = previousValue[dropDownNo];
}
else if (arraySelected == 1) {
AddToggledItem(dropDownNo, previousValue2[dropDownNo]);
preValue = previousValue2[dropDownNo];
}
else if (arraySelected == 2) {
AddToggledItem(dropDownNo, previousValue3[dropDownNo]);
preValue = previousValue3[dropDownNo];
}


if (preValue == "Creation Time" || preValue == "Suspension Time" || preValue == "Error Description") {
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

if (preValue == "Application Name" || preValue == "Host Name" || preValue == "Instance Status" || preValue == "Group Results By" || preValue == "Pending Operations") {
var ddlApp = document.getElementById("drpValue" + dropDownNo);
while (ddlApp.length > 0) {
ddlApp.remove(ddlApp.length - 1);
}
}

if (preValue == "Group Results By") {
orderedGroup = "";
}

if (currentValue == "Creation Time" || currentValue =="Suspension Time") {
var ddl2add = document.getElementById("drpOperator" + dropDownNo);
ddl2add.remove(0);

for (var j = 0; j < 2; j++) {
var opth = document.createElement("option");
opth.value = arrayOperator[j];
opth.text = arrayOperator[j];
document.getElementById("drpOperator" + dropDownNo).options.add(opth);
}

document.getElementById("drpOperator" + dropDownNo).selectedIndex = 0;
AddTextBoxRemoveDDLBox(preValue, currentValue, dropDownNo);
}

if (currentValue == "Error Description") {
var ddl2add = document.getElementById("drpOperator" + dropDownNo);
ddl2add.remove(0);

for (var j = 0; j < errorDescription.length; j++) {
var opth = document.createElement("option");
opth.value = errorDescription[j];
opth.text = errorDescription[j];
document.getElementById("drpOperator" + dropDownNo).options.add(opth);
}

document.getElementById("drpOperator" + dropDownNo).selectedIndex = 0;
}

if (currentValue == "Service Instance ID" || currentValue == "Error Code" || currentValue == "Error Description") {
AddTextBoxRemoveDDLBox(preValue, currentValue,  dropDownNo);
}
if (currentValue == "Application Name" || currentValue == "Group Results By" || currentValue == "Host Name" || currentValue == "Instance Status" || currentValue == "Pending Operations") {
AddDDLBoxRemoveTextBox(preValue,currentValue, dropDownNo)
}

ResetCSVArrays(preValue, currentValue);
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

if (arraySelected == 0) {
ReindexMainArray(previousValue[dropDownNo]);
previousValue[dropDownNo] = currentValue;
}
else if (arraySelected == 1) {
ReindexMainArray(previousValue2[dropDownNo]);
previousValue2[dropDownNo] = currentValue;
}
else if (arraySelected == 2) {
ReindexMainArray(previousValue3[dropDownNo]);
previousValue3[dropDownNo] = currentValue;
}
}

function ResetCSVArrays(previousValue, currentValue) {
switch (previousValue) {
case "Application Name":
conditionArray[0] = 'N';
conditionValueArray[0] = "";
break;
case "Creation Time":
conditionArray[1] = 'N';
conditionValueArray[1] = "";
break;
case "Group Results By":
conditionArray[2] = 'N';
conditionValueArray[2] = "";
break;
case "Host Name":
conditionArray[3] = 'N';
conditionValueArray[3] = "";
break;
case "Instance Status":
conditionArray[4] = 'N';
conditionValueArray[4] = "";
break;
case "Service Instance ID":
conditionArray[5] = 'N';
conditionValueArray[5] = "";
break;
case "Pending Operations":
conditionArray[6] = 'N';
conditionValueArray[6] = "";
break;
case "Error Code":
conditionArray[7] = 'N';
conditionValueArray[7] = "";
break;
case "Error Description":
conditionArray[8] = 'N';
conditionValueArray[8] = "";
break;
case "Suspension Time":
conditionArray[9] = 'N';
conditionValueArray[9] = "";
break;

}

switch (currentValue) {
case "Application Name":
conditionArray[0] = 'Y';
break;
case "Creation Time":
conditionArray[1] = 'Y';
break;
case "Group Results By":
conditionArray[2] = 'Y';
break;
case "Host Name":
conditionArray[3] = 'Y';
break;
case "Instance Status":
conditionArray[4] = 'Y';
break;
case "Service Instance ID":
conditionArray[5] = 'Y';
break;
case "Pending Operations":
conditionArray[6] = 'Y';
break;
case "Error Code":
conditionArray[7] = 'Y';
break;
case "Error Description":
conditionArray[8] = 'Y';
break;
case "Suspension Time":
conditionArray[9] = 'Y';
break;
}
}

function AddDDLBoxRemoveTextBox(previousvalue, currentVal, dropdownID) {
var statusArray = [];
var groupArray = [];

switch (arraySelected) {
case 0:
statusArray = instanceStatus;
groupArray = grouping1;
break;
case 1:
statusArray = instanceStatus1;
groupArray = grouping2;
break;
case 2:
statusArray = instanceStatus2;
groupArray = grouping3;
break;
}
    
if (previousvalue == "Creation Time" || previousvalue == "Suspension Time" || previousvalue == "Error Code" || previousvalue == "Error Description" || previousvalue == "Service Instance ID") {
HandleDDLBoxOnToggle(dropdownID, currentVal);

}
else {
var par = jQuery_1_8_3("#" + "drpValue" + dropdownID).parent();
jQuery_1_8_3("#" + "drpValue" + dropdownID).remove();
jQuery_1_8_3("#" + "aTag" + dropdownID).remove();
var cellNo = document.getElementById(par[0].id);
        
switch (previousvalue) {
case "Application Name":
jQuery_1_8_3('.drpValueApp').remove();
break;
case "Host Name":
jQuery_1_8_3('.drpValueHost').remove();
break;
case "Group Results By":
jQuery_1_8_3('.drpValueGroup').remove();
break;
case "Instance Status":
if (arraySelected == 2) {
jQuery_1_8_3('.drpValueSuspendedStatus').remove();
}
break;
}

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + dropdownID;
newDropDown3.setAttribute("id", _select_id3);

switch (currentVal) {
case "Application Name":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueApp");
break;
case "Host Name":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueHost");
break;
case "Group Results By":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
break;
case "Pending Operations":
newDropDown3.setAttribute("class", "drpValue");
break;
case "Instance Status":
if (arraySelected == 2) {
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueSuspendedStatus");
}
else {
newDropDown3.setAttribute("class", "drpValue");
}
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
case "Application Name":
var appNames = document.getElementById("<%= hdnAppName.ClientID %>").value.split(";");
PopulateDDList(dropdownID, appNames);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[0] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All Applications",
allSelected: "All Applications Selected"
});
break;
case "Host Name":
var hostNames = document.getElementById("<%= hdnHostName.ClientID %>").value.split(";");
PopulateDDList(dropdownID, hostNames);

var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[3] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All Hosts",
allSelected: "All Hosts Selected"
});
break;
case "Pending Operations":
var pendingOp = ["Suspend", "Terminate"]
PopulateDDList(dropdownID, pendingOp);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[6] = fieldName;

break;
case "Group Results By":
PopulateDDList(dropdownID, groupArray);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
orderedGroup = fieldName;
conditionValueArray[2] = fieldName;

jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
break;
case "Instance Status":
PopulateDDList(dropdownID, statusArray);
var ddlField = document.getElementById("drpValue" + dropdownID);
var fieldName = ddlField.options[ddlField.selectedIndex].value;
conditionValueArray[4] = fieldName;

if (arraySelected == 2) {
jQuery_multiselect('#' + "drpValue" + dropdownID).multipleSelect({
placeholder: "Select Here",
selectAllText: "Select All"
});
}
break;
}
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);

statusArray = [];
groupArray = [];
}

function AddTextBoxRemoveDDLBox(previousvalue, currentVal, dropdownID) {
if (previousvalue == "Application Name" || previousvalue == "Host Name" || previousvalue == "Pending Operations" || previousvalue == "Group Results By" || previousvalue == "Instance Status") {
HandleTextBoxOnToggle(dropdownID, currentVal, 0, previousvalue);
}
else if (previousvalue == "Error Code" || previousvalue == "Error Description" || previousvalue == "Service Instance ID") {
if (currentVal == "Creation Time" || currentVal == "Suspension Time") {
jQuery_date(function () {
jQuery_date("#txtValue" + dropdownID).datetimepicker();
});
}
}
else if (previousvalue == "Creation Time" || previousvalue == "Suspension Time") {
    if (currentVal == "Error Code" || currentVal == "Error Description" || currentVal == "Service Instance ID" || currentVal == "Creation Time" || currentVal == "Suspension Time") {
HandleTextBoxOnToggle(dropdownID, currentVal, 1, previousvalue);
}
}
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

function HandleTextBoxOnToggle(dropDownNo, currentFieldValue, textStatus, previousFieldValue) {
var par;
if (textStatus == 0) {
par = jQuery_1_8_3("#" + "drpValue" + dropDownNo).parent();
jQuery_1_8_3("#" + "drpValue" + dropDownNo).remove();
jQuery_1_8_3("#" + "aTag" + dropDownNo).remove();

switch (previousFieldValue) {
case "Application Name":
jQuery_1_8_3('.drpValueApp').remove();
break;
case "Host Name":
jQuery_1_8_3('.drpValueHost').remove();
break;
case "Group Results By":
jQuery_1_8_3('.drpValueGroup').remove();
break;
case "Instance Status":
if (arraySelected == 2) {
jQuery_1_8_3('.drpValueSuspendedStatus').remove();
}
break;
}
}
else {
par = jQuery_1_8_3("#" + "txtValue" + dropDownNo).parent();
jQuery_1_8_3("#" + "txtValue" + dropDownNo).remove();
jQuery_1_8_3("#" + "aTag" + dropDownNo).remove();
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

if (currentFieldValue == "Creation Time" || currentFieldValue == "Suspension Time") {
jQuery_date(function () {
jQuery_date("#txtValue" + dropDownNo).datetimepicker();
});
}
}

function HandleDDLBoxOnToggle(dropDownNo, currentSelectedvalue) {
var par = jQuery_1_8_3("#" + "txtValue" + dropDownNo).parent();
var cellNo = document.getElementById(par[0].id);

var newDropDown3 = document.createElement("select");
var _select_id3 = "drpValue" + dropDownNo;
newDropDown3.setAttribute("id", _select_id3);

switch (currentSelectedvalue) {
case "Application Name":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueApp");
break;
case "Host Name":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueHost");
break;
case "Group Results By":
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueGroup");
break;
case "Pending Operations":
newDropDown3.setAttribute("class", "drpValue");
break;
case "Instance Status":
if (arraySelected == 2) {
newDropDown3.setAttribute("multiple", "multiple");
newDropDown3.setAttribute("class", "drpValueSuspendedStatus");
}
else {
newDropDown3.setAttribute("class", "drpValue");
}
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

function RePopulateAllDropDownlist(dropDownNo) {
for (var k = 0; k < dropDownNo; k++) {
var ddl = document.getElementById("drpField" + k);
if (ddl != null) {
for (i = 0; i < ddl.length; i++) {
if (arraySelected == 0) {
if (ddl.options[i].value == array1[0]) {
ddl.remove(i);
break;
}
}
else if (arraySelected == 1) {
if (ddl.options[i].value == array2[0]) {
ddl.remove(i);
break;
}
}
else if (arraySelected == 2) {
if (ddl.options[i].value == array3[0]) {
ddl.remove(i);
break;
}
}
}
}
}
}

function ReToggleAllDropDownlist(dropDownNo,currentValue) {
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

function ReindexMainArray(previousValue) {
if (arraySelected == 0) {
var newArray = [];
for (var k = 0; k < sID; k++) {
var ddlist = document.getElementById("drpField" + k);
if (ddlist != null) {
newArray[k] = ddlist.options[ddlist.selectedIndex].value;
}
}
for (var newCount = 0; newCount < newArray.length; newCount++) {
for (var count = 0; count < array1.length; count++) {
if (newArray[newCount] == array1[count]) {
array1[count] = previousValue;
break;
}
}
}
}
else if (arraySelected == 1) {
var newArray = [];
for (var k = 0; k < sID; k++) {
var ddlist = document.getElementById("drpField" + k);
if (ddlist != null) {
newArray[k] = ddlist.options[ddlist.selectedIndex].value;
}
}
for (var newCount = 0; newCount < newArray.length; newCount++) {
for (var count = 0; count < array2.length; count++) {
if (newArray[newCount] == array2[count]) {
array2[count] = previousValue;
break;
}
}
}
}
if (arraySelected == 2) {
var newArray = [];
for (var k = 0; k < sID; k++) {
var ddlist = document.getElementById("drpField" + k);
if (ddlist != null) {
newArray[k] = ddlist.options[ddlist.selectedIndex].value;
}
}
for (var newCount = 0; newCount < newArray.length; newCount++) {
for (var count = 0; count < array3.length; count++) {
if (newArray[newCount] == array3[count]) {
array3[count] = previousValue;
break;
}
}
}
}
}

function RemoveAndToggle(id) {
var dropDownNo = id.substring(4);
var fieldValue = document.getElementById("drpField" + dropDownNo).value;
    
if (arraySelected == 0) {
AddToggledItem(dropDownNo, previousValue[dropDownNo]);
array1.push(previousValue[dropDownNo]);
}
else if (arraySelected == 1) {
AddToggledItem(dropDownNo, previousValue2[dropDownNo]);
array2.push(previousValue2[dropDownNo]);
}
else if (arraySelected == 2) {
AddToggledItem(dropDownNo, previousValue3[dropDownNo]);
array3.push(previousValue3[dropDownNo]);
}

switch (fieldValue) {
case "Application Name":
conditionArray[0] = 'N';
conditionValueArray[0]="";
break;
case "Creation Time":
conditionArray[1] = 'N';
conditionValueArray[1] = "";
break;
case "Group Results By":
conditionArray[2] = 'N';
conditionValueArray[2] = "";
orderedGroup = "";
break;
case "Host Name":
conditionArray[3] = 'N';
conditionValueArray[3] = "";
break;
case "Instance Status":
conditionArray[4] = 'N';
conditionValueArray[4] = "";
break;
case "Service Instance ID":
conditionArray[5] = 'N';
conditionValueArray[5] = "";
break;
case "Pending Operations":
conditionArray[6] = 'N';
conditionValueArray[6] = "";
break;
case "Error Code":
conditionArray[7] = 'N';
conditionValueArray[7] = "";
break;
case "Error Description":
conditionArray[8] = 'N';
conditionValueArray[8] = "";
break;
case "Suspension Time":
conditionArray[9] = 'N';
conditionValueArray[9] = "";
break;

}
document.getElementById("<%= hdnConditions.ClientID %>").value = ReturnCSVArray(conditionArray);
document.getElementById("<%= hdnValues.ClientID %>").value = ReturnCSVArray(conditionValueArray);
}
</script>
<script type = "text/javascript">
jQuery_1_8_3('.aTag').live('click', function () {
RemoveAndToggle(this.id);
jQuery_1_8_3(this).parent().parent().remove();

});

function NoCheckMouseEvents(objRef, evt) {
if (evt.type == "mouseover") {
objRef.style.backgroundColor = "#CCFFFF";
}
else if (evt.type == "mouseout") {
if (objRef.rowIndex % 2 == 0) {
//Alternating Row Color
objRef.style.backgroundColor = "white";
}
else {
objRef.style.backgroundColor = "#EFF3FB";
}
}
}

function SelectAll(myvar) {
var IsChecked = myvar.checked;
var Chk = myvar;
Parent = document.getElementById("<%= grdViewGroup.ClientID %>");
var items = Parent.getElementsByTagName('input');
var itemCount = 0;

for (i = 0; i < items.length; i++) {

if (items[i].id != Chk && items[i].type == "checkbox") {

if (items[i].checked != IsChecked) {
items[i].click();
}
}
}
}

function SelectAllO(myvar) {
var IsChecked = myvar.checked;
var Chk = myvar;
Parent = document.getElementById("<%= gridViewAll.ClientID %>");
var items = Parent.getElementsByTagName('input');
var itemCount = 0;

for (i = 0; i < items.length; i++) {

if (items[i].id != Chk && items[i].type == "checkbox") {

if (items[i].checked != IsChecked) {
items[i].click();
}
}
}
}

function Check_Click(objRef) {
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var grid = document.getElementById("<%= grdViewGroup.ClientID %>");

var atleastOneSuspended = false;
var atleastOneActiveDehydrated = false;


for (var j = 0; j < inputList.length; j = j + 1) {
if (inputList[j].type == "checkbox") {
if (inputList[j].checked) {
var cellStatus = grid.rows[j + 1].cells[6].innerHTML;
if (cellStatus == "Suspended Resumable" || cellStatus == "Suspended Non-Resumable") {
atleastOneSuspended = true;
break;
}
}
}
}

for (var k = 0; k < inputList.length; k = k + 1) {
if (inputList[k].type == "checkbox") {
if (inputList[k].checked) {
var cellStatus = grid.rows[k + 1].cells[6].innerHTML;
if (cellStatus == "Dehydrated" || cellStatus == "Active" || cellStatus == "Ready To Run") {
atleastOneActiveDehydrated = true;
break;
}
}
}
}

for (var i = 0; i < inputList.length; i = i + 1) {
var checked = true;
if (inputList[i].type == "checkbox") {
if (!inputList[i].checked) {
checked = false;
break;
}
}
}

if (atleastOneSuspended && atleastOneActiveDehydrated) {
document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value = "0";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = true;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'gray'; 

document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkTerminate.ClientID %>").value = "Terminate";
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'white';

document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'white';
}
else if (atleastOneActiveDehydrated) {
document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnMainText.ClientID %>").value = "0";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Suspend";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'white';

document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkTerminate.ClientID %>").value = "Terminate";
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'white';

document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'white';
}
else if (atleastOneSuspended) {
document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnMainText.ClientID %>").value = "1";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Resume";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'white';

document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkTerminate.ClientID %>").value = "Terminate";
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'white';

document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'white';
}
else if (!atleastOneSuspended && !atleastOneActiveDehydrated) {
document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value = "0";
document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value = "0";
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = true;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'gray'; 

document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = true;
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'gray';

document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'gray';
}
document.getElementById("<%= chkAll.ClientID %>").checked = checked;
}

function Check_ClickO(objRef) {
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var grid = document.getElementById("<%= gridViewAll.ClientID %>");

var atleastOneSuspended = false;
var atleastOneActiveDehydrated = false;


for (var j = 0; j < inputList.length; j = j + 1) {
if (inputList[j].type == "checkbox") {
if (inputList[j].checked) {
var cellStatus = grid.rows[j + 1].cells[6].innerHTML;
if (cellStatus == "Suspended Resumable" || cellStatus == "Suspended Non-Resumable") {
atleastOneSuspended = true;
break;
}
}
}
}

for (var k = 0; k < inputList.length; k = k + 1) {
if (inputList[k].type == "checkbox") {
if (inputList[k].checked) {
var cellStatus = grid.rows[k + 1].cells[6].innerHTML;
if (cellStatus == "Dehydrated" || cellStatus == "Active" || cellStatus == "Ready To Run") {
atleastOneActiveDehydrated = true;
break;
}
}
}
}

for (var i = 0; i < inputList.length; i = i + 1) {
var checked = true;
if (inputList[i].type == "checkbox") {
if (!inputList[i].checked) {
checked = false;
break;
}
}
}

if (atleastOneSuspended && atleastOneActiveDehydrated) {
document.getElementById("<%= hdnOCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.color = 'gray'; 
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").value = "Terminate";
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
else if (atleastOneActiveDehydrated) {
document.getElementById("<%= hdnOCheckBoxDehydratedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnOCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnOMainText.ClientID %>").value = "0";
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").value = "Suspend";
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.color = 'white';

document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").value = "Terminate";
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'white';

document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
else if (atleastOneSuspended) {
document.getElementById("<%= hdnOCheckBoxSuspendedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnOCheckBoxDehydratedChk.ClientID %>").value = "1";
document.getElementById("<%= hdnOMainText.ClientID %>").value = "1";
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").value = "Resume";
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.color = 'white';

document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").value = "Terminate";
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'white';

document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
else if (!atleastOneSuspended && !atleastOneActiveDehydrated) {
document.getElementById("<%= hdnOCheckBoxSuspendedChk.ClientID %>").value = "0";
document.getElementById("<%= hdnOCheckBoxDehydratedChk.ClientID %>").value = "0";

document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.color = 'gray'; 
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'gray';

document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnDownloadInstance.ClientID %>").value = "Download";
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'gray';
}
document.getElementById("<%= ChkOAll.ClientID %>").checked = checked;
}
</script>
<script type="text/javascript">
// JavaScript funciton to call inside UpdatePanel
function jScript() {
jQuery_1_8_3(document).ready(function () {
jQuery_1_8_3("th").addClass('rightborder');
});
jQuery_1_8_3(document).ready(function () {
jQuery_1_8_3("th").attr("align", "left");
});

var isBoth = false;
var executedWithGroup = document.getElementById("<%= hdnExecutedWithGroup.ClientID %>").value;

if (conditionArray[2] == "Y" || executedWithGroup=="1") {
isBoth = true;
}

if (isBoth) {

jQuery_1_8_3('#divA').removeClass('FullGridDock');
jQuery_1_8_3('#divB').removeClass('MinGridDock');

jQuery_1_8_3('#divA').addClass('FullGridDock');
jQuery_1_8_3('#divB').addClass('MinGridDock');

jQuery_1_8_3('#divA').width(1);
jQuery_1_8_3('#divB').width(1);

jQuery_1_8_3('#divA').width(jQuery_1_8_3('#dvScreenWidth').width()-8);
jQuery_1_8_3('#divB').width(jQuery_1_8_3('#dvScreenWidth').width()-8);
}
else {
jQuery_1_8_3('#divA').removeClass('GridDockDivA');
jQuery_1_8_3('#divB').removeClass('GridDock');

jQuery_1_8_3('#divA').addClass('GridDockDivA');
jQuery_1_8_3('#divB').addClass('GridDock');

jQuery_1_8_3('#divA').width(jQuery_1_8_3('#dvScreenWidth').width() - 8);
}
jQuery_1_8_3('form').live("submit", function () {
    jQuery_1_8_3('#<%=pnlInstanceConfirm.ClientID %>').hide();
    jQuery_1_8_3('#<%=pnlInstanceSuspendConfirmation.ClientID %>').hide();
    jQuery_1_8_3('#<%=pnlConfirmation.ClientID %>').hide();
    jQuery_1_8_3('#<%=pnlSuspendConfirmation.ClientID %>').hide();
});
}

jQuery_1_8_3(document).ready(function () {
    jQuery_1_8_3('#divA').addClass('GridDockDivA');
jQuery_1_8_3('#divB').addClass('GridDock');
//jQuery_1_8_3('#divA').width(jQuery_1_8_3('#dvScreenWidth').width() - 8);
});
</script>
<script type="text/javascript" language="javascript">  
function ShowPopup() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlpopup.ClientID %>').show();
}
function HidePopup() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlpopup.ClientID %>').hide();
}
jQuery_1_8_3(".btnClose").live('click', function () {
HidePopup();
if (document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'white'; 
if (document.getElementById("<%= hdnMainText.ClientID %>").value == "0") {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Suspend";
}
else {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Resume";
}
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'white';
}
if (document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'white';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkDownloadInstance.ClientID %>").style.color = 'white';
}
});

function ShowPopup1() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlPopOuter.ClientID %>').show();
}

function HidePopup1() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlPopOuter.ClientID %>').hide();
}

function ShowErrorMask() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlErrorMask.ClientID %>').show();
}

function HideErrorMask() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlErrorMask.ClientID %>').hide();
}

function ShowValidationError() {
    jQuery_1_8_3('#mask').show();
    jQuery_1_8_3('#<%=pnlValidationError.ClientID %>').show();
}

function HideValidationError() {
    jQuery_1_8_3('#mask').hide();
    jQuery_1_8_3('#<%=pnlValidationError.ClientID %>').hide();
}

jQuery_1_8_3(".btnValidationCloseBox").live('click', function () {
    HideValidationError();
});

jQuery_1_8_3(".btnCloseErrorBox").live('click', function () {
HideErrorMask();
});

function ShowConfirmationMask() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlConfirmation.ClientID %>').show();
document.getElementById("<%= btnConfirm.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnCancelRequest.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnConfirm.ClientID %>").style.color = 'white';
document.getElementById("<%= btnCancelRequest.ClientID %>").style.color = 'white'; 
}

function HideConfirmationMask() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlConfirmation.ClientID %>').hide();
RestoreDisplay();
}

function ShowInstanceConfirmationMask() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlInstanceConfirm.ClientID %>').show();
document.getElementById("<%= btnConfrimInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnCancelInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnConfrimInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnCancelInstance.ClientID %>").style.color = 'white'; 
document.getElementById("<%= lblConfirmationInstance.ClientID %>").innerHTML = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to" + "</span><span style=\"color: red\">" + " TERMINATE " + "</span><span style=\"color: gray\">" + "service instance(s) ?  " + "</b></span></pre>";
}

function HideInstanceConfirmationMask() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlInstanceConfirm.ClientID %>').hide();
RestoreODisplay();
}

function ShowSuspendConfirmationMask() {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlSuspendConfirmation.ClientID %>').show();
document.getElementById("<%= btnSuspendConfirm.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnSuspendCancelRequest.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnSuspendConfirm.ClientID %>").style.color = 'white';
document.getElementById("<%= btnSuspendCancelRequest.ClientID %>").style.color = 'white'; 
}

function HideSuspendConfirmationMask() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlSuspendConfirmation.ClientID %>').hide();
RestoreDisplay(); 
}

function ShowInstanceSuspendConfirmationMask(message) {
jQuery_1_8_3('#mask').show();
jQuery_1_8_3('#<%=pnlInstanceSuspendConfirmation.ClientID %>').show();
document.getElementById("<%= btnInstanceSuspendConfirm.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnInstanceSuspendCancelRequest.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnInstanceSuspendConfirm.ClientID %>").style.color = 'white';
document.getElementById("<%= btnInstanceSuspendCancelRequest.ClientID %>").style.color = 'white'; 
document.getElementById("<%= lblInstanceSuspendConfirmation.ClientID %>").innerHTML = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to " + "</span><span style=\"color: red\">" + message + "</span><span style=\"color: gray\">" + " service instance(s) ?  " + "</b></span></pre>";
}

function HideInstanceSuspendConfirmationMask() {
jQuery_1_8_3('#mask').hide();
jQuery_1_8_3('#<%=pnlInstanceSuspendConfirmation.ClientID %>').hide();
RestoreODisplay();
}

jQuery_1_8_3(".btnClose1").live('click', function () {
HidePopup1();
RestoreODisplay();
});

function RestoreDisplay() {
if (document.getElementById("<%= hdnCheckBoxDehydratedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").style.color = 'white';
if (document.getElementById("<%= hdnMainText.ClientID %>").value == "0") {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Suspend";
}
else {
document.getElementById("<%= btnBulkSuspendResume.ClientID %>").value = "Resume";
}
}
if (document.getElementById("<%= hdnCheckBoxSuspendedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnBulkTerminate.ClientID %>").disabled = false;
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnBulkTerminate.ClientID %>").style.color = 'white';
}
}

function RestoreODisplay() {
if (document.getElementById("<%= hdnOCheckBoxDehydratedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").style.color = 'white';
if (document.getElementById("<%= hdnOMainText.ClientID %>").value == "0") {
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").value = "Suspend";
}
else {
document.getElementById("<%= btnSuspendResumeInstance.ClientID %>").value = "Resume";
}
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
if (document.getElementById("<%= hdnOCheckBoxSuspendedChk.ClientID %>").value == "1") {
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
}
</script>
<style type="text/css">
a.no-line,a.no-line:link,a.no-line:hover,a.no-line:active
{
text-decoration: none;
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
.drpValueSuspendedStatus
{
color: #999999;
font-family: Arial Unicode MS;
font-size: Small;
font-weight: normal;
height: 25px; 
width: 80%;
}
.aTag
{
text-decoration: none;
height: 30px;
font-size: small;
color: #3399FF; 
text-align: right;
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
.GridDock
{
overflow: auto;
width: 1px;
height:1px;
padding: 0 0 0 0;
}
.GridDockDivA
{
overflow: auto;
width: 100px;
height:450px;
padding: 0 0 0 0;
}
.FullGridDock
{
overflow: auto;
width: 200px;
height:150px;
padding: 0 0 0 0;
}
.MinGridDock
{
overflow: auto;
width: 200px;
height:250px;
padding: 0 0 0 0;
}
.rightborder
{
border: 1px white;
border-style: solid;
border-right-color: Gray;
border-bottom-color:Gray;
border-spacing:none;
}
.loading
{
font-family: Arial;
font-size: 10pt;
position: fixed;
background-color: transparent;
z-index: 99;
opacity: 0.8;
filter: alpha(opacity=80);
-moz-opacity: 0.8;
min-height: 100%;
width: 100%;
}
.ButtonClass
{
cursor: pointer;
}
.modal
{
position: fixed;
z-index: 999;
height: 100%;
width: 100%;
top: 0;
left:0;
background-color: Black;
filter: alpha(opacity=60);
opacity: 0.6;
-moz-opacity: 0.8;
}
.center
{
z-index: 1000;
margin: 300px auto;
padding: 10px;
width: 130px;
background-color: White;
border-radius: 10px;
filter: alpha(opacity=100);
opacity: 1;
-moz-opacity: 1;
text-align:center;
}
.topDIVBorder
{
    border: 2px white;
    border-style: solid;
    border-top-color:#E8E8E8;
    
}
</style>
<style type="text/css">
#mask
{
position: fixed;
left: 0px;
top: 0px;
z-index: 4;
opacity: 0.4;
-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=40)"; /* first!*/
filter: alpha(opacity=40); /* second!*/
background-color: gray;
display: none;
width: 100%;
height: 100%;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div id="dvScreenWidth" visible="false"></div>
<asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"/>
<script type="text/javascript">
    var xPos, yPos, xPosB, yPosB, xPosC, yPosC, xPosD, yPosD;
// Get the instance of PageRequestManager.
var prm = Sys.WebForms.PageRequestManager.getInstance();
// Add initializeRequest and endRequest
prm.add_initializeRequest(prm_InitializeRequest);
prm.add_endRequest(prm_EndRequest);

// Called when async postback begins
function prm_InitializeRequest(sender, args) {
// get the divImage and set it to visible
// Disable button that caused a postback
$get(args._postBackElement.id).disabled = true;
xPos = $get('divA').scrollLeft;
yPos = $get('divA').scrollTop;
xPosB = $get('divB').scrollLeft;
yPosB = $get('divB').scrollTop;

var postBackElement = args.get_postBackElement();
if (postBackElement.id != 'ContentPlaceHolder1_grdViewGroup' && postBackElement.id != 'ContentPlaceHolder1_Menu1' && postBackElement.id != 'ContentPlaceHolder1_ddlOInstanceData' && postBackElement.id != 'ContentPlaceHolder1_Menu2' && postBackElement.id != 'ContentPlaceHolder1_ddlInstanceData' && postBackElement.id != 'ContentPlaceHolder1_gridViewAll' && postBackElement.id != 'ContentPlaceHolder1_gridViewOuterInstanceData' && postBackElement.id != 'ContentPlaceHolder1_btnSuspendResumeInstance' && postBackElement.id != 'ContentPlaceHolder1_btnTerminateInstance' && postBackElement.id != 'ContentPlaceHolder1_btnBulkSuspendResume' && postBackElement.id != 'ContentPlaceHolder1_btnBulkTerminate') {
    var panelProg = $get('divImage');
    panelProg.style.display = '';
}
}
// Called when async postback ends
function prm_EndRequest(sender, args) {
// get the divImage and hide it again
var panelProg = $get('divImage');
panelProg.style.display = 'none';

$get('divA').scrollLeft = xPos;
$get('divA').scrollTop = yPos;
$get('divB').scrollLeft = xPosB;
$get('divB').scrollTop = yPosB;

// Enable button that caused a postback
// $get(sender._postBackSettings.sourceElement.id).disabled = false;
}
</script>
<asp:HiddenField id="hdnMainText" runat="server" Value="0" />
<asp:HiddenField id="hdnOMainText" runat="server" Value="0" />
<asp:HiddenField id="hdnAppName" runat="server" />
<asp:HiddenField id="hdnHostName" runat="server" />
<asp:HiddenField id="hdnConditions" runat="server" Value ="N;N;N;N;N;N;N;N;N;N"/>
<asp:HiddenField id="hdnOperator" runat="server" value="=;>=;=;=;=;=;=;=;=;>="/>
<asp:HiddenField id="hdnValues" runat="server" Value=" ; ; ; ; ; ; ; ; ; ;" />
<asp:HiddenField id="hdnMainArray" runat="server" Value="0" />
<asp:HiddenField id="hdnCount" runat="server" Value="10" />
<div id ="divImage" class="modal" style="display:none">
<div class="center">
<img alt="" src="Images/loading1.gif" />
<br /><span  style="color:gray"><b>Please wait</b></span>
</div>
</div>
<table style="height:100%;width:99%;">
<tr>
<td>
<div style="padding: 5px; width:99%;">
<a id="divHeader" class="no-line" href="javascript:toggle2('divMain','divHeader','divFilter');"           
style="border-style: none; font-size: large; color: #006699; font-weight: bold;" >
<img src="Images/collapse.jpg" alt="tog" style="background-color: #FFFFFF; border-style: none" />
Build Query </a>
</div>
</td>
</tr>
<tr>
<td>
<div id="divMain" style="display: block;padding: 5px; width:99%;border-left-style:solid;border-left-color:Olive;">
<table style="height:100%;width:100%;">
<tr>
<td style="font-size: small;width:20%; color: #3399FF; text-align: left;">Field Name</td>
<td style="font-size: small; width: 15%; color: #3399FF; text-align: left;">Count (per MsgBox)</td>
<td style="font-size: small;width:65%; color: #3399FF; text-align: left;"></td>
</tr>
<tr>
<td>
<asp:DropDownList ID="drpMain" runat="server" Width="100%" Height="25px" 
Font-Bold="False" Font-Names="Arial Unicode MS" Font-Size="Small" 
ForeColor="#999999" onchange="DecideArrayType()">
<asp:ListItem>All Service Instances</asp:ListItem>
<asp:ListItem>Running Service Instances</asp:ListItem>
<asp:ListItem>Suspended Service Instances</asp:ListItem>
</asp:DropDownList>
</td>
<td><asp:DropDownList ID="drpMaxmatch" runat="server" Width="100%"  Height="25px" 
Font-Bold="False" Font-Names="Arial Unicode MS" Font-Size="Small" 
ForeColor="#999999" onchange="UpdateCount()">
<asp:ListItem>10</asp:ListItem>
<asp:ListItem>25</asp:ListItem>
<asp:ListItem>50</asp:ListItem>
<asp:ListItem>100</asp:ListItem>
<asp:ListItem>200</asp:ListItem>
<asp:ListItem>500</asp:ListItem>
</asp:DropDownList></td>
<td>
<asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
<ContentTemplate>
<asp:HiddenField id="hdnExecutedWithGroup" runat="server" Value="0" />
<asp:Button ID="btnExecuteQuery" runat="server" Text="Run Query" BorderStyle="None" 
        Width="120px" Height="25px" 
Font-Bold="False" Font-Size="Small" BackColor="#F88017" 
        onclick="btnExecuteQuery_Click" CssClass="ButtonClass" ForeColor="White"/>
</ContentTemplate>
<Triggers>
<asp:AsyncPostBackTrigger ControlID="btnExecuteQuery" EventName="Click" />
</Triggers>
</asp:UpdatePanel>
</td>
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
<div id="divFilter" style="display: block;padding: 5px; width:99%;">
<a id="aFilter" class="no-line" href="#" onclick="AddFilter()" 
style="border-style: none; font-size: large; color: #006699; font-weight: bold;"><img src="Images/AddFilter.jpg" alt="add" style="background-color: #FFFFFF; border-style: none" />Add a Filter</a></div>
</td>
</tr>
<tr>
<td align="left">
</td>
</tr>
<tr>
<td style="padding-left:8px;">
<asp:UpdatePanel ID="updatePnlGroup" runat="server" UpdateMode="Conditional" >
<ContentTemplate>
<script type="text/javascript" language="javascript">
Sys.Application.add_load(jScript);
</script>
<asp:HiddenField id="hdnCheckBoxDehydratedChk" runat="server" Value="0" />
<asp:HiddenField id="hdnCheckBoxSuspendedChk" runat="server" Value="0" />
&nbsp;&nbsp;<asp:CheckBox ID="chkAll"  onclick="SelectAll(this);" 
runat="server" BorderStyle="None" Visible="False" Text="    " 
Width="40px" Height="25px" />  
<asp:Button ID="btnBulkSuspendResume" runat="server" Text="Suspend" 
BorderStyle="None" Enabled="False" Visible="False" Height="25px" Width="100px" 
onclick="btnBulkSuspendResume_Click" CssClass="ButtonClass"
/>
<asp:Button ID="btnBulkTerminate" runat="server" Text="Terminate" 
BorderStyle="None"  Enabled="False"  Visible="False"  Height="25px" 
Width="100px" onclick="btnBulkTerminate_Click" CssClass="ButtonClass" />
<asp:Button ID="btnBulkDownloadInstance" runat="server" BorderStyle="None" 
        CssClass="ButtonClass" Enabled="False" Height="25px" Text="Download" 
        Visible="False" Width="80px" onclick="btnBulkDownloadInstance_Click" />
<table>
<tr>
<td style="height:5px;"></td>
</tr>
</table>
<div id="divA">
<asp:GridView ID="grdViewGroup" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8" HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White"
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" 
Visible="False"   OnRowDataBound = "grdViewGroup_RowDataBound" 
OnSelectedIndexChanged = "grdViewGroup_SelectedIndexChanged" 
OnRowCommand="grdViewGroup_RowCommand" OnSorting="grdViewGroup_Sorting" height="100%" width ="100%" 
        AllowSorting="True">
<Columns>
<asp:TemplateField HeaderText="">
<ItemTemplate>
<asp:CheckBox ID="chkGridBox"  runat="server" onclick="Check_Click(this)"  />
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="View" SortExpression="">
<ItemTemplate>
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View Instance Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("Instance ID") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
</Columns>
<AlternatingRowStyle BackColor="#EFF3FB" Wrap="False" ForeColor="Black" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<EmptyDataRowStyle Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" Font-Size="Smaller" />
<RowStyle BackColor="White" Font-Size="Smaller" Wrap="False" ForeColor="Black" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
<div id="errorMask"></div>
<asp:Panel ID="pnlErrorMask" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:550px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Error Message
</td>
</tr>
<tr>
<td>
<a id="A6" style="color:#FFFFFF; float: left;text-decoration:none" href="#">
<img src="Images/Error_warning_icon.jpg" alt="X"/></a><asp:label ID="lblErrorMask" runat="server" ReadOnly="true"></asp:label>
</td>
</tr>
<tr>
<td>
<a id="aCloseBox" style="color:#FFFFFF; float: right;text-decoration:none" class="btnCloseErrorBox"  href="#">
<img src="Images/CloseButton.jpg" alt="X"/></a>
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlValidationError" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:auto;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Validation Error
</td>
</tr>
<tr>
<td>
<asp:label ID="lblvalidationError" runat="server" ReadOnly="true"></asp:label>
</td>
</tr>
<tr>
<td>
<a id="aClosevalidationBox" style="color:#FFFFFF; float: right;text-decoration:none" class="btnValidationCloseBox"  href="#">
<img src="Images/CloseButton.jpg" alt="X"/></a>
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlConfirmation" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:530px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Confirmation
</td>
</tr>
<tr>
<td>
<a id="A2" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/questionMarkIcon.jpg" alt="X"/></a><asp:label ID="lblConfirmation" runat="server" TextMode="MultiLine" ReadOnly="true"  Visible="true"></asp:label>
</td>
</tr>
<tr>
<td align="center">
<asp:Button ID="btnConfirm" runat="server" BackColor="#F88017" ForeColor="White" Text="Confirm" BorderStyle="None"  Visible="true" onclick="btnConfirm_Click" Height="30px" CssClass="ButtonClass"
Width="80px" />
<asp:Button ID="btnCancelRequest" runat="server" BackColor="#F88017" ForeColor="White" OnClientClick="HideConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass" />
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlInstanceConfirm" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:530px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Confirmation
</td>
</tr>
<tr>
<td>
<a id="A3" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/questionMarkIcon.jpg" alt="X"/></a><asp:label ID="lblConfirmationInstance" runat="server" TextMode="MultiLine" ReadOnly="true"  Visible="true"></asp:label>
</td>
</tr>
<tr>
<td align="center">
<asp:Button ID="btnConfrimInstance" runat="server" Text="Confirm" BorderStyle="None"  Visible="true" onclick="btnConfirmInstance_Click" Height="30px" CssClass="ButtonClass"
Width="80px" />
<asp:Button ID="btnCancelInstance" runat="server" OnClientClick="HideInstanceConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass" />
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlSuspendConfirmation" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:530px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Confirmation
</td>
</tr>
<tr>
<td>
<a id="A4" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/questionMarkIcon.jpg" alt="X"/></a><asp:label ID="lblSuspendConfirmation" runat="server" TextMode="MultiLine" ReadOnly="true"  Visible="true"></asp:label>
</td>
</tr>
<tr>
<td align="center">
<asp:Button ID="btnSuspendConfirm" BackColor="#F88017" ForeColor="White" runat="server" Text="Confirm"  BorderStyle="None"  Visible="true" onclick="btnSuspendConfirm_Click" Height="30px"  CssClass="ButtonClass"
Width="80px" />
<asp:Button ID="btnSuspendCancelRequest" BackColor="#F88017" ForeColor="White" runat="server" OnClientClick="HideSuspendConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass"/>
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlInstanceSuspendConfirmation" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:530px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Confirmation
</td>
</tr>
<tr>
<td>
<a id="A5" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/questionMarkIcon.jpg" alt="X"/></a><asp:label ID="lblInstanceSuspendConfirmation" runat="server" TextMode="MultiLine" ReadOnly="true"  Visible="true"></asp:label>
</td>
</tr>
<tr>
<td align="center">
<asp:Button ID="btnInstanceSuspendConfirm" runat="server" Text="Confirm" BorderStyle="None"  Visible="true" onclick="btnInstanceSuspendConfirm_Click" Height="30px" CssClass="ButtonClass"
Width="80px" />
<asp:Button ID="btnInstanceSuspendCancelRequest" runat="server" OnClientClick="HideInstanceSuspendConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass"/>
</td>
</tr>
</table>
</asp:Panel>
<div id="mask"></div>
<asp:Panel ID="pnlpopup" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:65%; width:75%;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td colspan="3" style="color:White; font-weight: bold; font-size: 1.2em; padding:3px; width: 100%;" align="left">
Instance Details 
<a id="closebtn" style="color:#33CCFF; float: right;text-decoration:none" class="btnClose"  href="#">
<img src="Images/Close.jpg" alt="X"/></a>
</td>
</tr>
<tr>
<td colspan="3" style="height:1px"></td>
</tr>
<tr>
<td colspan="3" style="width:100%">
<asp:Menu ID="Menu1" Orientation="Horizontal" runat="server" onmenuitemclick="Menu1_MenuItemClick" BorderStyle="None" Font-Size="Medium" ForeColor="Gray" Width="99%" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="6px" Height="30px" Font-Size="Medium" Width="90px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Medium" BorderStyle="None" CssClass="textAlign" Width="200px" />
<Items>
<asp:MenuItem  Text="" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="MESSAGE INFORMATION" Value="1"></asp:MenuItem>           
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="8px" Font-Size="Medium" Height="30px" Width="200px" BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Medium" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="200px" ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" Font-Size="Medium" />
</asp:Menu>
<div id ="barDiv" class="topDIVBorder"></div>
</td>
</tr>
<tr>
<td colspan="3" valign="top">
<asp:MultiView ID="MultiView1" ActiveViewIndex="0" runat="server">
<asp:View ID="View1" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left; width:100%;height:25px;" colspan="4">
<asp:Label ID="lblServiceNameValue" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td style="height:1px;" colspan="4">
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="Label5" runat="server" Text="Application:" Font-Size="Small" ForeColor="#003399"> </asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblAppName" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left">
<asp:label ID="Label1" runat="server" Text="Host:" Font-Size="Small" ForeColor="#003399"> </asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblHostname" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="Label7" runat="server" Text="Instance Status:" Font-Size="Small" ForeColor="#003399"> </asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblInstanceStatus" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left">
<asp:label ID="Label2" runat="server" Text="Instance ID:" Font-Size="Small" ForeColor="#003399"> </asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblInstanceID" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="lblCT" runat="server" Text="Creation Time:" Font-Size="Small" ForeColor="#003399"></asp:label>
</td>
<td align="left" style="text-align:left;height:20px;">
<asp:Label ID="lblCreationTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left" style="width:20%;">
<asp:label ID="Label3" runat="server" Text="Processing Server:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td align="left" style="text-align:left;width:30%;">
<asp:Label ID="lblServer" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="width:20%;height:20px;">
<asp:label ID="lblSuspendtext" runat="server" Text="Suspend Time:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td align="left" style="text-align:left; width:30%;">
<asp:Label ID="lblSuspendTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td>
<asp:label ID="lblErrorCodeText" runat="server" Text="Error Code:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td>
<asp:Label ID="lblErrorCode" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"> </asp:Label>
</td>
</tr>
<tr>
<td align="left" colspan="4" style="height:20px;">
<asp:Label ID="lblErrorDesc" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="#003399"> </asp:Label>
</td>
</tr>
<tr>
<td colspan="4" style="height:250px;width:100%;">
<asp:TextBox ID="txtErrorDetail" runat="server" TextMode="MultiLine" ReadOnly="true" Width="99%" Height="99%" ForeColor="gray"></asp:TextBox>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View2" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:Label ID="Label8" Font-Size="Small" Visible="true" ForeColor="#003399" runat="server" Text="Select Message Type"></asp:Label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;">
<asp:DropDownList ID="ddlInstanceData" runat="server"  ForeColor="gray" Width="99%" AutoPostBack="true" Font-Size="Small" OnSelectedIndexChanged="ddlInstanceData_SelectedIndexChanged">
</asp:DropDownList>
</td>
</tr>
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:label ID="lblMsgID" runat="server" Text="Message ID:" Font-Size="Small" Visible="false" ForeColor="#003399"> </asp:label>
</td>
<td align="left" style="text-align:left; height:20px;">
<asp:Label ID="lblMessageID" runat="server" Font-Bold="True"  Visible="false" Font-Size="Small" ForeColor="gray"> </asp:Label>
</td>
</tr>
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:Label ID="lblMsgTypetext" runat="server" Text="Message Type:" Font-Size="Small" Visible="false" ForeColor="#003399"></asp:Label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;">
<asp:Label ID="lblMessageTypeValue" runat="server" Font-Bold="True"  Visible="false" Font-Size="Small" ForeColor="gray" ></asp:Label>
</td>
</tr>
<tr>
<td  style="height:340px;width:100%;" colspan="2">
<asp:TextBox ID="txtDetail" runat="server" Width="99%" Height="99%" TextMode="MultiLine" ReadOnly="true" ForeColor="Green"></asp:TextBox>
</td>
</tr>
</table>
</asp:View> 
</asp:MultiView>
</td>
</tr>
</table>
</asp:Panel>
</ContentTemplate>
<Triggers>
<asp:AsyncPostBackTrigger ControlID="btnExecuteQuery" EventName="Click" />
<asp:PostBackTrigger ControlID="btnBulkDownloadInstance" />
</Triggers>
</asp:UpdatePanel>
</td>
</tr>
<tr>
<td style="height:5px;"></td>
</tr>
<tr>
<td>
<asp:UpdatePanel ID="UpdatePanelAll" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="True">
<ContentTemplate>
<asp:HiddenField id="hdnOCheckBoxDehydratedChk" runat="server" Value="0" />
<asp:HiddenField id="hdnOCheckBoxSuspendedChk" runat="server" Value="0" />
&nbsp;&nbsp;<asp:CheckBox ID="ChkOAll"  onclick="SelectAllO(this);" 
runat="server" BorderStyle="None" Visible="False" Text="    " 
Width="40px" Height="25px" />  
<asp:Button ID="btnSuspendResumeInstance" runat="server" Text="Suspend" BorderStyle="None" Enabled="False" Visible="False" Height="25px" Width="80px"  
OnClientClick="return ConfirmOnTerminate();" CssClass="ButtonClass"
onclick="btnSuspendResumeInstance_Click" />
<asp:Button ID="btnTerminateInstance" runat="server" Text="Terminate" 
BorderStyle="None" Enabled="False" Visible="False"  Height="25px"  Width="80px" 
onclick="btnTerminateInstance_Click" CssClass="ButtonClass" />
<asp:Button ID="btnDownloadInstance" runat="server" Text="Download" 
        BorderStyle="None" Enabled="False" Visible="False" Height="25px" Width="80px" 
        CssClass="ButtonClass" onclick="btnDownloadInstance_Click" />
<table>
<tr>
<td style="height:5px;"></td>
</tr>
</table>
<div id="divB">
<asp:GridView ID="gridViewAll" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8" HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" 
Visible="False" DataKeyNames="Instance ID"                     
OnRowCommand="gridViewAll_RowCommand"
OnRowDataBound = "gridViewAll_RowDataBound" AllowSorting="True" OnSorting="gridViewAll_Sorting">
<Columns>
<asp:TemplateField HeaderText="">
<ItemTemplate>
<asp:CheckBox ID="chkSingleBox"  runat="server"  onclick="Check_ClickO(this)" />
</ItemTemplate>
</asp:TemplateField>
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
</div>
<div id="maskOuter"></div>
<asp:Panel ID="pnlPopOuter" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:60%; width:70%;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td colspan="3" style="color:White; font-weight: bold; font-size: 1.2em; padding:3px; width: 100%;" align="left">
Instance Details 
<a id="A1" style="color:#33CCFF; float: right;text-decoration:none" class="btnClose1"  href="#">
<img src="Images/Close.jpg" alt="X"/></a>
</td>
</tr>
<tr>
<td colspan="3" style="height:1px"></td>
</tr>
<tr>
<td colspan="3" style="width:100%">
<asp:Menu ID="Menu2" Orientation="Horizontal" runat="server" onmenuitemclick="Menu2_MenuItemClick" BorderStyle="None" Font-Size="Medium" ForeColor="Gray" Width="99%">
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="6px" Height="30px" Font-Size="Medium" Width="200px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Medium" BorderStyle="None" CssClass="textAlign" Width="200px" />
<Items>
<asp:MenuItem  Text="" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="MESSAGE INFORMATION" Value="1"></asp:MenuItem>           
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="8px" Font-Size="Medium" Height="30px" Width="200px" BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Medium" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="200px" ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" Font-Size="Medium" />
</asp:Menu>
<div id ="Div1" class="topDIVBorder"></div>
</td>
</tr>
<tr>
<td colspan="3" valign="top">
<asp:MultiView ID="MultiView2" ActiveViewIndex="0" runat="server">
<asp:View ID="ViewO1" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left; width:100%;height:25px;" colspan="4">
<asp:Label ID="lblOServiceNameValue" runat="server" Font-Bold="True" Font-Size="small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td style="height:1px;" colspan="4">
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="Label6" runat="server" Text="Application:" Font-Size="Small" ForeColor="#003399">
</asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOAppName" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left">
<asp:label ID="Label9" runat="server" Text="Host:" Font-Size="Small" ForeColor="#003399">
</asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOHostname" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="Label4" runat="server" Text="Instance Status:" Font-Size="Small" ForeColor="#003399"/></td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOInstanceStatus" runat="server" Font-Bold="true" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left"><asp:label ID="lblOInstanceIDText" runat="server" Text="Instance ID:" Font-Size="Small" ForeColor="#003399"/></td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOInstanceID" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="lblOCT" runat="server" Text="Creation Time:" Font-Size="Small" ForeColor="#003399"></asp:label></td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOCreationTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left" style="width:20%;">
<asp:label ID="Label11" runat="server" Text="Processing Server:" Font-Size="Small" ForeColor="#003399"/></td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOServer" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="width:20%;height:20px;">
<asp:label ID="lblOSuspendtext" runat="server" Text="Suspend Time:" Font-Size="Small" Visible="false" ForeColor="#003399"></asp:label></td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblOSuspendTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray" Visible="false"></asp:Label>
</td>
<td>
<asp:label ID="lblErrorOCodeText" runat="server" Text="Error Code:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td>
<asp:Label ID="lblErrorOCode" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray">
</asp:Label>
</td>
</tr>
<tr>
<td align="left" colspan="4" style="height:20px;">
<asp:Label ID="lblOErrorDesc" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="#003399">
</asp:Label>
</td>
</tr>
<tr>
<td colspan="4" style="height:250px; width:100%">
<asp:TextBox ID="txtOErrorDetail" runat="server" TextMode="MultiLine" ReadOnly="true" Width="99%" Height="99%"  ForeColor="gray"></asp:TextBox>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="ViewO2" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:Label ID="Label10" Font-Size="Small" Visible="true" ForeColor="#003399" runat="server" Text="Select Message Type"></asp:Label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;">
<asp:DropDownList ID="ddlOInstanceData" runat="server"  ForeColor="gray" Width="99%"
AutoPostBack="true" Font-Size="Small" OnSelectedIndexChanged="ddlOInstanceData_SelectedIndexChanged">
</asp:DropDownList>
</td>
</tr>
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:label ID="lblOMsgID" runat="server" Text="Message ID:" Font-Size="Small" Visible="false" ForeColor="#003399"></asp:label>
</td>
<td align="left" style="text-align:left;"><asp:Label ID="lblOMessageID" runat="server" Font-Bold="True"  Visible="false"
Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:Label ID="lblMsgOTypetext" runat="server" Text="Message Type:" Font-Size="Small" Visible="false" ForeColor="#003399"></asp:Label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;">
<asp:Label ID="lblMessageOTypeValue" runat="server" Font-Bold="True"  Visible="false" Font-Size="Small" ForeColor="gray" ></asp:Label>
</td>
</tr>
<tr>
<td  style="height:340px;width:100%;" colspan="2">
<asp:TextBox ID="txtODetail" runat="server" Width="99%" Height="99%" TextMode="MultiLine" ReadOnly="true" ForeColor="Green"></asp:TextBox>
</td>
</tr>
</table>
</asp:View> 
</asp:MultiView>
</td>
</tr>
</table>
</asp:Panel>
</ContentTemplate>
<Triggers>
<asp:AsyncPostBackTrigger ControlID="grdViewGroup" EventName="SelectedIndexChanged" />
<asp:AsyncPostBackTrigger ControlID="btnExecuteQuery" EventName="Click" />
<asp:AsyncPostBackTrigger ControlID="btnConfrimInstance" EventName="Click" />
<asp:AsyncPostBackTrigger ControlID="btnInstanceSuspendConfirm" EventName="Click" />
<asp:AsyncPostBackTrigger ControlID="grdViewGroup" EventName="Sorting" />
<asp:PostBackTrigger ControlID="btnDownloadInstance" />
</Triggers>
</asp:UpdatePanel>
</td>
</tr>
</table>
</asp:Content>
