/* conditionArray mapping Y/N
0-Application Name
1-Host Name
2-Status
3-Is Two Way
4-Transport Type
5-Pipeline Type
6-Source Schema
7-Target Schema
8-Schema Type
*/

var odx = ["Application Name", "Status","Host Name"];
var rp = ["Application Name", "Is Two Way"];
var rl = ["Application Name", "Status", "Host Name", "Transport Type"];
var sp = ["Application Name", "Status", "Host Name", "Transport Type"];
var spg = ["Application Name", "Status"];
var btp = ["Application Name", "Pipeline Type"];
var btm = ["Application Name", "Source Schema", "Target Schema"];
var xsd = ["Application Name", "Schema Type"];
var status_1 = ["Started", "Stopped", "Unenlisted"];
var status_2 = ["Enabled", "Disabled"];
var pipeline = ["Receive", "Send"];
var schemaType = ["Property", "Document"];
var trueFalse = ["True", "False"];
var previousValue = [];
var conditionArray = ["N", "N", "N", "N", "N", "N", "N", "N", "N"];
var conditionValueArray = ["", "", "", "", "", "", "", "", ""];

function toggle2(showHideDiv, switchTextDiv, switchFilter) {

    var ele = document.getElementById(showHideDiv);
    var ele1 = document.getElementById(switchFilter);
    var text = document.getElementById(switchTextDiv);

    if (ele.style.display == "block") {
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

function ResetConditionAnDValues() {
    conditionArray = ["N", "N", "N", "N", "N", "N", "N", "N", "N"];
    conditionValueArray = ["", "", "", "", "", "", "", "", ""];
    document.getElementById("ContentPlaceHolder1_hdnCondition").value = ReturnCSVArray(conditionArray);
    document.getElementById("ContentPlaceHolder1_hdnConditionValues").value = ReturnCSVArray(conditionValueArray);
}

function DeleteAllRows() {
    $('.aTag').parent().parent().remove();
    ResetConditionAnDValues();
    previousValue = [];
}

function AddFilter() {
    var hdnfilter = document.getElementById('ContentPlaceHolder1_hdnFilterCount');
    var sID = parseInt(hdnfilter.value);
    var ddlmain = document.getElementById('ContentPlaceHolder1_drpMain');
    var artefact = ddlmain.options[ddlmain.selectedIndex].value;
    var arrayString = document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value;

    var arrayCondition = null;
    if (arrayString) {
        arrayCondition = arrayString.split(",");
    }

    if (artefact != "Application" && arrayString) {
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

        PopulateDropDownList(_select_id,1,_ddl_no,cell3);
        PopulateDropDownList(_select_id2,2,_ddl_no,cell3);

        cell3.appendChild(aTag);

        arrayCondition.reverse();
        arrayCondition.pop();
        arrayCondition.reverse();

        newDropDown1.selectedIndex = 0;
        newDropDown2.selectedIndex = 0;

        newDropDown1.onchange = function () { ToggleArray(_select_id); };
        aTag.setAttribute("href", "#");
        newDropDown2.onchange = function () { UpdateOperator(_select_id2); };

        sID = sID + 1;
        document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value = arrayCondition;
        document.getElementById("ContentPlaceHolder1_hdnFilterCount").value = sID;
    }
}

function PopulateDropDownList(dropDownID, dropdownType, currentDropDownID, cellID) {
    if (dropdownType == 1) {
        var dropDownNo = dropDownID.substring(8);
        var arrayString = document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value;
        var arrayCondition = null;
        if (arrayString) {
            arrayCondition = arrayString.split(",");
        }
        for (var i = 0; i < arrayCondition.length; i++) {
            var opt = document.createElement("option");
            opt.value = arrayCondition[i];
            opt.text = arrayCondition[i];
            document.getElementById(dropDownID).options.add(opt);
        }

        document.getElementById(dropDownID).selectedIndex = 0;
        previousValue[dropDownNo] = arrayCondition[0];
        RePopulateAllDropDownlist(currentDropDownID);

        SetConitions(arrayCondition[0]);

        document.getElementById("ContentPlaceHolder1_hdnCondition").value = ReturnCSVArray(conditionArray);
        

        var ddlmain = document.getElementById(dropDownID);
        var condition = ddlmain.options[ddlmain.selectedIndex].value;
        PopulateConditionValueDropdownlist(condition, cellID, currentDropDownID);
    }
    else if (dropdownType == 2) {

        var opte = document.createElement("option");
        opte.value = "Is equal to";
        opte.text = "Is equal to";
        document.getElementById(dropDownID).options.add(opte);
        document.getElementById(dropDownID).selectedIndex = 0;
    }
}

function PopulateConditionValueDropdownlist(condition, cellID, currentDropDownID) {
    var ddlmain = document.getElementById('ContentPlaceHolder1_drpMain');
    var artefact = ddlmain.options[ddlmain.selectedIndex].value;
    var conditionValues = null;
    var valPos = 0;
    switch (condition) {
        case "Application Name":
            conditionValues = document.getElementById("ContentPlaceHolder1_hdnAppName").value.split(";");
            valPos = 0;
            break;
        case "Status":
            switch (artefact) {
                case "Orchestration":
                    conditionValues = status_1;
                    break;
                case "Send Port":
                    conditionValues = status_1;
                    break;
                case "Send Port Group":
                    conditionValues = status_1;
                    break;
                case "Receive Location":
                    conditionValues = status_2;
                    break;
            }
            valPos = 2;
            break;
        case "Host Name":
            conditionValues = document.getElementById("ContentPlaceHolder1_hdnHostName").value.split(";");
            valPos = 1;
            break;
        case "Is Two Way":
            conditionValues = trueFalse;
            valPos = 3;
            break;
        case "Transport Type":
            conditionValues = document.getElementById("ContentPlaceHolder1_hdnTransportTypes").value.split(";");
            valPos = 4;
            break;
        case "Pipeline Type":
            conditionValues = pipeline;
            valPos = 5;
            break;
        case "Schema Type":
            conditionValues = schemaType;
            valPos = 8;
            break;
        case "Source Schema":
            conditionValues = document.getElementById("ContentPlaceHolder1_hdnSourceSchema").value.split(";");
            valPos = 6;
            break;
        case "Target Schema":
            conditionValues = document.getElementById("ContentPlaceHolder1_hdnTargetSchema").value.split(";");
            valPos = 7;
            break;
    }

    var newDropDown3 = document.createElement("select");
    var _select_id3 = "drpValue" + currentDropDownID;
    newDropDown3.setAttribute("id", _select_id3);
    newDropDown3.setAttribute("class", "drpValue");
    cellID.appendChild(newDropDown3);

    newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };

    for (var optionCount = 0; optionCount < conditionValues.length; optionCount++) {
        var optStatus = document.createElement("option");
        optStatus.value = conditionValues[optionCount];
        optStatus.text = conditionValues[optionCount];
        document.getElementById("drpValue" + currentDropDownID).options.add(optStatus);
    }

    newDropDown3.selectedIndex = 0;
    conditionValueArray[valPos] = newDropDown3[0].text;
    document.getElementById("ContentPlaceHolder1_hdnConditionValues").value = ReturnCSVArray(conditionValueArray);
}

function ToggleArray(_select_id) {
    var ddl = document.getElementById(_select_id);
    var dropDownNo = _select_id.substring(8);
    var currentValue = ddl.options[ddl.selectedIndex].value;
    var preValue = "";
    var valPos = 0;
    ReToggleAllDropDownlist(dropDownNo, currentValue);
    AddToggledItem(dropDownNo, previousValue[dropDownNo]);
    preValue = previousValue[dropDownNo];

    var ddlApp = document.getElementById("drpValue" + dropDownNo);
    while (ddlApp.length > 0) {
        ddlApp.remove(ddlApp.length - 1);
    }

    var par = $("#" + "drpValue" + dropDownNo).parent();
    $("#" + "drpValue" + dropDownNo).remove();
    $("#" + "aTag" + dropDownNo).remove();
    
    var cellNo = document.getElementById(par[0].id);
    var newDropDown3 = document.createElement("select");
    var _select_id3 = "drpValue" + dropDownNo;
    
    newDropDown3.setAttribute("id", _select_id3);
    newDropDown3.setAttribute("class", "drpValue");
    var txt = document.createTextNode(" Remove")
    var aTag = document.createElement("a");
    var _select_aid = "aTag" + dropDownNo;
    var ddlmain = document.getElementById('ContentPlaceHolder1_drpMain');
    var artefact = ddlmain.options[ddlmain.selectedIndex].value;

    aTag.setAttribute("id", _select_aid);
    aTag.setAttribute("class", "aTag");
    aTag.appendChild(txt);
    aTag.setAttribute("href", "#");

    cellNo.appendChild(newDropDown3);
    cellNo.appendChild(aTag);

    newDropDown3.onchange = function () { ToggleValueArray(_select_id3); };

    switch (currentValue) {
        case "Host Name":
            var hostNames = document.getElementById("ContentPlaceHolder1_hdnHostName").value.split(";");
            PopulateDDList(dropDownNo, hostNames);
            valPos = 1;
            break;
        case "Application Name":
            var appNames = document.getElementById("ContentPlaceHolder1_hdnAppName").value.split(";");
            valPos = 0;
            PopulateDDList(dropDownNo, appNames);
            break;
        case "Transport Type":
            var tranportType = document.getElementById("ContentPlaceHolder1_hdnTransportTypes").value.split(";");
            PopulateDDList(dropDownNo, tranportType);
            valPos = 4;
            break;
        case "Status":
            switch (artefact) {
                case "Orchestration":
                    PopulateDDList(dropDownNo, status_1);
                    break;
                case "Send Port":
                    PopulateDDList(dropDownNo, status_1);
                    break;
                case "Send Port Group":
                    PopulateDDList(dropDownNo, status_1);
                    break;
                case "Receive Location":
                    PopulateDDList(dropDownNo, status_2);
                    conditionValues = status_2;
                    break;
            }
            valPos = 2;
            break;
        case "Is Two Way":
            PopulateDDList(dropDownNo, trueFalse);
            valPos = 3;
            break;
        case "Pipeline Type":
            PopulateDDList(dropDownNo, pipeline);
            valPos = 5;
            break;
        case "Schema Type":
            PopulateDDList(dropDownNo, schemaType);
            valPos = 8;
            break;
        case "Source Schema":
            var sourceSchemas = document.getElementById("ContentPlaceHolder1_hdnSourceSchema").value.split(";");
            PopulateDDList(dropDownNo, sourceSchemas);
            valPos = 6;
            break;
        case "Target Schema":
            var targetSchemas = document.getElementById("ContentPlaceHolder1_hdnTargetSchema").value.split(";");
            PopulateDDList(dropDownNo, targetSchemas);
            valPos = 7;
            break;
    }

    ResetCSVArrays(previousValue[dropDownNo], currentValue);
    document.getElementById("ContentPlaceHolder1_hdnCondition").value = ReturnCSVArray(conditionArray);

    conditionValueArray[valPos] = newDropDown3[0].text;
    document.getElementById("ContentPlaceHolder1_hdnConditionValues").value = ReturnCSVArray(conditionValueArray);
    
    ReindexMainArray(previousValue[dropDownNo]);
    previousValue[dropDownNo] = currentValue;
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
                conditionValueArray[0] = currentValue;
                break;
            case "Host Name":
                conditionValueArray[1] = currentValue;
                break;
            case "Status":
                conditionValueArray[2] = currentValue;
                break;
            case "Is Two Way":
                conditionValueArray[3] = currentValue;
                break;
            case "Transport Type":
                conditionValueArray[4] = currentValue;
                break;
            case "Pipeline Type":
                conditionValueArray[5] = currentValue;
                break;
            case "Source Schema":
                conditionValueArray[6] = currentValue;
                break;
            case "Target Schema":
                conditionValueArray[7] = currentValue;
                break;
            case "Schema Type":
                conditionValueArray[8] = currentValue;
                break;
        }
    }

    document.getElementById("ContentPlaceHolder1_hdnConditionValues").value = ReturnCSVArray(conditionValueArray);
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

function UpdateOperator(ddlOperatorID) {
}

function ReindexMainArray(previousValue) {
    var hdnfilter = document.getElementById('ContentPlaceHolder1_hdnFilterCount');
    var sID = parseInt(hdnfilter.value);
    var newArray = [];
    var arrayString = document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value;
    var arrayCondition = null;
    if (arrayString) {
        arrayCondition = arrayString.split(",");
    }
    for (var k = 0; k < sID; k++) {
        var ddlist = document.getElementById("drpField" + k);
        if (ddlist != null) {
            newArray[k] = ddlist.options[ddlist.selectedIndex].value;
        }
    }
    for (var newCount = 0; newCount < newArray.length; newCount++) {
        for (var count = 0; count < arrayCondition.length; count++) {
            if (newArray[newCount] == arrayCondition[count]) {
                arrayCondition[count] = previousValue;
                break;
            }
        }
    }
    document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value = arrayCondition;

}

function RePopulateAllDropDownlist(dropDownNo) {
    var arrayString = document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value;
    var arrayCondition = null;
    if (arrayString) {
        arrayCondition = arrayString.split(",");
    }
    for (var k = 0; k < dropDownNo; k++) {
        var ddl = document.getElementById("drpField" + k);
        if (ddl != null) {
            for (i = 0; i < ddl.length; i++) {
                if (ddl.options[i].value == arrayCondition[0]) {
                    ddl.remove(i);
                    break;
                }
            }
        }
    }
}

function ReturnCSVArray(mainArray) {
    var csvArray = "";
    for (var arrayCount = 0; arrayCount < mainArray.length; arrayCount++) {
        if (arrayCount == 0) {
            csvArray = mainArray[arrayCount]
        }
        else {
            csvArray = csvArray + "," + mainArray[arrayCount];
        }
    }
    return csvArray;
}

function SetConitions(currentValue) {
    switch (currentValue) {
        case "Application Name":
            conditionArray[0] = 'Y';
            break;
        case "Host Name":
            conditionArray[1] = 'Y';
            break;
        case "Status":
            conditionArray[2] = 'Y';
            break;
        case "Is Two Way":
            conditionArray[3] = 'Y';
            break;
        case "Transport Type":
            conditionArray[4] = 'Y';
            break;
        case "Pipeline Type":
            conditionArray[5] = 'Y';
            break;
        case "Source Schema":
            conditionArray[6] = 'Y';
            break;
        case "Target Schema":
            conditionArray[7] = 'Y';
            break;
        case "Schema Type":
            conditionArray[8] = 'Y';
            break;
    }
}

function ReturnPreviousIndex(previouValue) {
    var previousIndex = 0;
    switch (previouValue) {
        case "Application Name":
            previousIndex = 0;
            break;
        case "Host Name":
            previousIndex = 1;
            break;
        case "Status":
            previousIndex = 2;
            break;
        case "Is Two Way":
            previousIndex = 3;
            break;
        case "Transport Type":
            previousIndex = 4;
            break;
        case "Pipeline Type":
            previousIndex = 5;
            break;
        case "Source Schema":
            previousIndex = 6;
            break;
        case "Target Schema":
            previousIndex = 7;
            break;
        case "Schema Type":
            previousIndex = 8;
            break;
    }

    return previousIndex;
}

function ResetCSVArrays(previousValue, currentValue) {
    switch (previousValue) {
        case "Application Name":
            conditionArray[0] = 'N';
            conditionValueArray[0] = "";
            break;
        case "Host Name":
            conditionArray[1] = 'N';
            conditionValueArray[1] = "";
            break;
        case "Status":
            conditionArray[2] = 'N';
            conditionValueArray[2] = "";
            break;
        case "Is Two Way":
            conditionArray[3] = 'N';
            conditionValueArray[3] = "";
            break;
        case "Transport Type":
            conditionArray[4] = 'N';
            conditionValueArray[4] = "";
            break;
        case "Pipeline Type":
            conditionArray[5] = 'N';
            conditionValueArray[5] = "";
            break;
        case "Source Schema":
            conditionArray[6] = 'N';
            conditionValueArray[6] = "";
            break;
        case "Target Schema":
            conditionArray[7] = 'N';
            conditionValueArray[7] = "";
            break;
        case "Schema Type":
            conditionArray[8] = 'N';
            conditionValueArray[8] = "";
            break;
    }

    switch (currentValue) {
        case "Application Name":
            conditionArray[0] = 'Y';
            break;
        case "Host Name":
            conditionArray[1] = 'Y';
            break;
        case "Status":
            conditionArray[2] = 'Y';
            break;
        case "Is Two Way":
            conditionArray[3] = 'Y';
            break;
        case "Transport Type":
            conditionArray[4] = 'Y';
            break;
        case "Pipeline Type":
            conditionArray[5] = 'Y';
            break;
        case "Source Schema":
            conditionArray[6] = 'Y';
            break;
        case "Target Schema":
            conditionArray[7] = 'Y';
            break;
        case "Schema Type":
            conditionArray[8] = 'Y';
            break;
    }
}

function AddToggledItem(dropDownNo, previousValue) {
    var hdnfilter = document.getElementById('ContentPlaceHolder1_hdnFilterCount');
    var sID = parseInt(hdnfilter.value);
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

function ReToggleAllDropDownlist(dropDownNo, currentValue) {
    var hdnfilter = document.getElementById('ContentPlaceHolder1_hdnFilterCount');
    var sID = parseInt(hdnfilter.value);

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

function RemoveAndToggle(id) {
    var dropDownNo = id.substring(4);
    var fieldValue = document.getElementById("drpField" + dropDownNo).value;

    var arrayString = document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value;
    var arrayCondition = null;
    arrayCondition = arrayString.split(",");

    if (!arrayString) {
        arrayCondition.pop();
    }

    ResetCSVArrays(fieldValue, "");

    AddToggledItem(dropDownNo, fieldValue)
    arrayCondition.push(fieldValue);

    document.getElementById("ContentPlaceHolder1_hdnCondition").value = ReturnCSVArray(conditionArray);
    document.getElementById("ContentPlaceHolder1_hdnConditionValues").value = ReturnCSVArray(conditionValueArray);
    document.getElementById("ContentPlaceHolder1_hdnArtefactFilter").value = arrayCondition;
}

function ReturnArtefactFilters(artefact) {

    var artefactFilterArray = "";

    switch (artefact) {
        case "Transform":
            artefactFilterArray = btm;
            break;
        case "Orchestration":
            artefactFilterArray = odx;
            break;
        case "Pipeline":
            artefactFilterArray = btp;
            break;
        case "Receive Location":
            artefactFilterArray = rl;
            break;
        case "Receive Port":
            artefactFilterArray = rp;
            break;
        case "Schemas":
            artefactFilterArray = xsd;
            break;
        case "Send Port":
            artefactFilterArray = sp;
            break;
        case "Send Port Group":
            artefactFilterArray = spg;
            break;
    }
    return artefactFilterArray;
}