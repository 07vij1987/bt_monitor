<%@ Page EnableEventValidation="false" Title="Monitor | Suspensions"  MaintainScrollPositionOnPostback="true" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="SuspensionMonitor.aspx.cs" Inherits="BizTalk_Monitor.SuspensionMonitor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link type="text/css" href="Styles/ui-lightness/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" language="javascript">
function jScript() {
$(document).ready(function () {
    $("th").attr("align", "left");
});

$(document).ready(function () {
    $("th").removeClass('rightborder');
    $("th").addClass('rightborder');
});

$('#a').width(1);
$('#ab').width(1);

$(document).ready(function () {
    $('#a').width($('#dvScreenWidth').width() - 8);
    $('#ab').width($('#dvScreenWidth').width() -8);
});


$('form').live("submit", function () {
    var btn = $(document.activeElement);
    if (btn[0].value != "Download" && btn[0].value != "Bulk Terminate" && btn[0].value != "Terminate Instance") {
        $('#<%=pnlConfirmation.ClientID %>').hide();
        $('#<%=pnlInstanceConfirm.ClientID %>').hide();
    }
});
} 

function Check_Click(objRef) {
var checked = true;
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var atleastOneChecked = false;

//if (objRef.checked) {
//    row.style.backgroundColor = "#EFF3FB";
//}
//else {
//row.style.backgroundColor = "white";
//}


for (var j = 0; j < inputList.length; j++) {
if (inputList[j].type == "checkbox") {
if (inputList[j].checked) {
atleastOneChecked = true;
break;
}
}
}

for (var i = 0; i < inputList.length; i++) {
//Based on all or none checkboxes are checked check/uncheck Header Checkbox
checked = true;
if (inputList[i].type == "checkbox") {
if (!inputList[i].checked) {
checked = false;
break;
}
}
}

if (atleastOneChecked) {
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "1";
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.visibility = "hidden";
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.display = "none";
document.getElementById('<%=btnIndividualInstance.ClientID %>').style.visibility = "visible";
document.getElementById("<%= btnResumeInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnResumeInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnResumeInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.color = 'white';          
}
else {
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0"
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.visibility = "visible";
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.display = "inline";
document.getElementById('<%=btnIndividualInstance.ClientID %>').style.visibility = "hidden";
document.getElementById("<%= btnResumeInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = true;
document.getElementById("<%= btnResumeInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnResumeInstance.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnTerminateInstance.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.color = 'gray'; 
}

document.getElementById("<%= chkAll.ClientID %>").checked = checked;
}

function SelectAllCheckboxesSpecific(spanChk) {
var IsChecked = spanChk.checked;
var Chk = spanChk;
Parent = document.getElementById("<%= grdViewInstancesDetails.ClientID %>");
var items = Parent.getElementsByTagName('input');
var itemCount = 0;

for (var chkCount = 0; chkCount < items.length; chkCount++) {

    if (items[chkCount].id != Chk && items[chkCount].type == "checkbox") {

        if (items[chkCount].checked != IsChecked) {
            items[chkCount].click();
        }
    } 
}
}

function MouseEvents(objRef, evt) {
var checkbox = objRef.getElementsByTagName("input")[0];
if (evt.type == "mouseover") {
objRef.style.backgroundColor = "#CCFFFF";
}
else {
if (checkbox.checked) {
objRef.style.backgroundColor = "#aac0e5";
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
}
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

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width() - 8);
$('#ab').width($('#dvScreenWidth').width());
});

function ShowPopup() {
$('#mask').show();
$('#<%=pnlpopup.ClientID %>').show();
}
function HidePopup() {
$('#mask').hide();
$('#<%=pnlpopup.ClientID %>').hide(); 
}

function ShowErrorMask() {
$('#mask').show();
$('#<%=pnlErrorMask.ClientID %>').show();
}


function ShowPanelMask() {
    $('#mask').show();
    $('#<%=pnlNosuspension.ClientID %>').show();
}
function HidePanelMask() {
    $('#mask').hide();
    $('#<%=pnlNosuspension.ClientID %>').hide();
}

function HideErrorMask() {
$('#mask').hide();
$('#<%=pnlErrorMask.ClientID %>').hide();
}

$(".btnCloseErrorBox").live('click', function () {
    HideErrorMask();
    HidePanelMask();
});


function ShowConfirmationMask() {
    $('#mask').show();
    $('#<%=pnlConfirmation.ClientID %>').show();
    document.getElementById("<%= btnConfirm.ClientID %>").style.backgroundColor = '#F88017';
    document.getElementById("<%= btnConfirm.ClientID %>").style.color = 'white';
    document.getElementById("<%= btnCancelRequest.ClientID %>").style.backgroundColor = '#F88017';
    document.getElementById("<%= btnCancelRequest.ClientID %>").style.color = 'white'; 
    document.getElementById("<%= lblConfirmation.ClientID %>").innerHTML = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to" + "</span><span style=\"color: red\">" + " BULK TERMINATE " + "</span><span style=\"color: gray\">" + "service instance(s) ?  " + "</b></span></pre>";
}

function ShowInstanceConfirmationMask() {
    $('#mask').show();
    $('#<%=pnlInstanceConfirm.ClientID %>').show();
    document.getElementById("<%= btnConfrimInstance.ClientID %>").style.backgroundColor = '#F88017';
    document.getElementById("<%= btnConfrimInstance.ClientID %>").style.color = 'white';
    document.getElementById("<%= btnCancelInstance.ClientID %>").style.backgroundColor = '#F88017';
    document.getElementById("<%= btnCancelInstance.ClientID %>").style.color = 'white'; 
    document.getElementById("<%= lblConfirmationInstance.ClientID %>").innerHTML = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to" + "</span><span style=\"color: red\">" + " TERMINATE " + "</span><span style=\"color: gray\">" + "service instance(s) ?  " + "</b></span></pre>";
}

function HideConfirmationMask() {
$('#mask').hide();
$('#<%=pnlConfirmation.ClientID %>').hide();
}

function HideInstanceConfirmationMask() {
    $('#mask').hide();
    $('#<%=pnlInstanceConfirm.ClientID %>').hide();
}

$(".btnClose").live('click', function () {
HidePopup();
if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value=="1") {
document.getElementById("<%= btnResumeInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnTerminateInstance.ClientID %>").disabled = false;
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.visibility = "hidden";
document.getElementById('<%=btnIndividualInstance.ClientID %>').style.visibility = "visible";
document.getElementById('<%=btnTerminateInstance.ClientID %>').style.display = "none";
document.getElementById("<%= btnDownloadInstance.ClientID %>").disabled = false;
document.getElementById("<%= btnResumeInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnResumeInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnIndividualInstance.ClientID %>").style.color = 'white';
document.getElementById("<%= btnDownloadInstance.ClientID %>").style.color = 'white';
}
});

$(document).ready(function () {
$("th").attr("align", "left");
});

$(document).ready(function () {
$("th").addClass('rightborder');
});

$(document).ready(function () {
    $('#a').width($('#dvScreenWidth').width() - 8);
    $('#ab').width($('#dvScreenWidth').width() - 8);
});

</script>
<style type="text/css">
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
<style type="text/css">
.GridDock
{
overflow: auto;
width: 200px;
height:335px;
padding: 0 0 17px 0;
}
.mainGridDock
{
overflow: auto;
width: 100px;
height:200px;
padding: 0 0 5px 0;
}
</style>
<style type="text/css">
.rightborder
{
border: 1px white;
border-style: solid;
border-right-color: Gray;
border-bottom-color:Gray;
border-spacing:none;
}
.border_bottom td {
  border-bottom:1pt solid lightgray;
}
.ButtonClass
{
    cursor: pointer;
}
.textAlign
{
text-align:center;
vertical-align:middle;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div id="dvScreenWidth" visible="false"></div>
<asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"/>
<script type="text/javascript">
    var xPos, yPos, xPosB, yPosB;
    // Get the instance of PageRequestManager.
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    // Add initializeRequest and endRequest
    prm.add_initializeRequest(prm_InitializeRequest);
    prm.add_endRequest(prm_EndRequest);

    // Called when async postback begins
    function prm_InitializeRequest(sender, args) {
        // Disable button that caused a postback
        $get(args._postBackElement.id).disabled = true;
        xPos = $get('a').scrollLeft;
        yPos = $get('a').scrollTop;
        xPosB = $get('ab').scrollLeft;
        yPosB = $get('ab').scrollTop;

        var postBackElement = args.get_postBackElement();
        if (postBackElement.id == 'ContentPlaceHolder1_grdViewMain' || postBackElement.id == 'ContentPlaceHolder1_btnServiceMessage' || postBackElement.id == 'ContentPlaceHolder1_ddlInstanceData' || postBackElement.id == 'ContentPlaceHolder1_btnDownloadInstance' || postBackElement.id == 'ContentPlaceHolder1_grdViewInstancesDetails' || postBackElement.id == 'ContentPlaceHolder1_Menu1') {
            $get('ContentPlaceHolder1_UpdateProgress1').style.display = 'none';
            var divloading = $get('divModal');
            divloading.style.display = 'none';
        }
        else {
            var panelProg = $get('divModal');
            panelProg.style.display = '';
        }

    }
    // Called when async postback ends
    function prm_EndRequest(sender, args) {
        // get the divImage and hide it again
        var panelProg = $get('divModal');
        panelProg.style.display = 'none';

        $get('a').scrollLeft = xPos;
        $get('a').scrollTop = yPos;
        $get('ab').scrollLeft = xPosB;
        $get('ab').scrollTop = yPosB;
        
       
        // Enable button that caused a postback
        // $get(sender._postBackSettings.sourceElement.id).disabled = false;
    }
</script>
<table style="height:99%;width:99%;">
<tr>
<td style="height:100%;width:100%;">
<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="updatePnlGroup">
<ProgressTemplate>
    <div id ="divModal" class="modal">
        <div class="center">
            <img alt="" src="Images/loading1.gif" />
            <br /><span  style="color:gray">Please wait</span>
        </div>
    </div>
</ProgressTemplate>
</asp:UpdateProgress>
<asp:UpdatePanel ID="updatePnlGroup" runat="server" UpdateMode="Conditional" >
<ContentTemplate>
<script type="text/javascript" language="javascript">
    Sys.Application.add_load(jScript);
</script>
<asp:HiddenField id="hdnCheckBoxChk" runat="server" Value="0" />
<table style="height:100%;width:100%;">
<tr><td colspan="2" style="Height: 5px; position: absolute;" bgcolor="White"></td></tr>
<tr>
<td style="padding-left:2px;">
<asp:Button ID="btnDualGetNRefresh" runat="server" Text="Refresh"  BorderStyle="None" Height="30px" onclick="btnDualGetNRefresh_Click" 
        Width="80px" BackColor="#F88017" CssClass="ButtonClass" ForeColor="White" Visible="False"/>             
<asp:Button ID="btnResume" runat="server" Text="Bulk Resume" BorderStyle="None" Enabled="False" Visible="False" onclick="btnResume_Click" Height="30px" Width="100px" CssClass="ButtonClass" />
<asp:Button ID="btnTerminate" runat="server" OnClientClick="ShowConfirmationMask();return false;" Text="Bulk Terminate" BorderStyle="None" Enabled="False" Visible="False"  Height="30px" Width="100px" CssClass="ButtonClass"/>
<asp:Button ID="btnServiceMessage" runat="server" Text="Download" BorderStyle="None" Enabled="False" Visible="False" Height="30px" Width="80px" onclick="btnServiceMessage_Click" CssClass="ButtonClass" />
</td>
<td align="right"></td>
</tr>
<tr><td colspan="2" style="Height: 8px;" bgcolor="White"></td></tr>
<tr>
<td colspan="2">
<div id="a" style ="height:200px; width:200px; overflow:auto;">
<asp:GridView ID="grdViewMain" runat="server" CellPadding="6" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewMain_RowDataBound" 
OnSelectedIndexChanged = "grdViewMain_SelectedIndexChanged"  OnPageIndexChanging = "grdViewMain_PageIndexChanging"
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" 
        Width="100%" AllowSorting="True" OnSorting="grdViewMain_Sorting"> 
<AlternatingRowStyle Wrap="False" BackColor="#EFF3FB" ForeColor="Black" />
<EditRowStyle BackColor="White" Wrap="False" />
<EmptyDataRowStyle Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" Font-Size="Smaller" />
<RowStyle Font-Size="Smaller" Wrap="False" BackColor="White" ForeColor="Black" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" ForeColor="White" 
        Wrap="False" BackColor="#43C6DB" />
<SortedAscendingCellStyle Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="White" Wrap="False" />
<SortedDescendingHeaderStyle Wrap="False" />
</asp:GridView>
<asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
</div>
<div id="errorMask"></div>
<asp:Panel ID="pnlErrorMask" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:550px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Message
</td>
</tr>
<tr>
<td>
<a id="A3" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/Error_warning_icon.jpg" alt="X"/></a><asp:label ID="lblErrorMask" runat="server" TextMode="MultiLine" ReadOnly="true" ></asp:label>
</td>
</tr>
<tr>
<td align="center">
<a id="aCloseBox" style="color:#FFFFFF; float: right;text-decoration:none" class="btnCloseErrorBox"  href="#">
<img src="Images/CloseButton.jpg" alt="X"/></a>
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlConfirmation" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:570px;
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
<asp:Button ID="btnConfirm" runat="server" Text="Confirm" BorderStyle="None"  Visible="true" onclick="btnConfirm_Click" Height="30px" Width="80px" CssClass="ButtonClass" />
<asp:Button ID="btnCancelRequest" runat="server" OnClientClick="HideConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass" />
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlInstanceConfirm" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:540px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Confirmation
</td>
</tr>
<tr>
<td>
<a id="A1" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/questionMarkIcon.jpg" alt="X"/></a><asp:label ID="lblConfirmationInstance" runat="server" TextMode="MultiLine" ReadOnly="true"  Visible="true"></asp:label>
</td>
</tr>
<tr>
<td align="center">
<asp:Button ID="btnConfrimInstance" runat="server" Text="Confirm" BorderStyle="None"  Visible="true" onclick="btnConfirmInstance_Click" Height="30px" CssClass="ButtonClass" Width="80px" />
<asp:Button ID="btnCancelInstance" runat="server" OnClientClick="HideInstanceConfirmationMask();return false;" Text="Cancel" BorderStyle="None"  Visible="true" Height="30px" Width="80px" CssClass="ButtonClass" />
</td>
</tr>
</table>
</asp:Panel>
<div id="mask"></div>
<asp:Panel ID="pnlNosuspension" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:auto; width:550px;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td style="color:White; font-weight: bold; font-size: 0.9em; padding:3px; width: 100%;" align="left">
BT Monitor Message
</td>
</tr>
<tr>
<td>
<a id="A4" style="color:#FFFFFF; float: left;text-decoration:none"   href="#">
<img src="Images/information.jpg" alt="X"/></a><asp:label ID="lblInfoMask" runat="server" TextMode="MultiLine" ReadOnly="true" ></asp:label>
</td>
</tr>
<tr>
<td align="center">
<a id="a5" style="color:#FFFFFF; float: right;text-decoration:none" class="btnCloseErrorBox"  href="#">
<img src="Images/CloseButton.jpg" alt="X"/></a>
</td>
</tr>
</table>
</asp:Panel>
<asp:Panel ID="pnlpopup" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:80%; width:80%;
left: 255px; top: 15%;  border: outset 2px gray;padding:5px;display:none">
<table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td colspan="3" style="color:White; font-weight: bold; font-size: 1.2em; padding:3px; width: 100%; height:5%;" align="left">
Suspended Instance Details 
<a id="closebtn" style="color:#33CCFF; float: right;text-decoration:none" class="btnClose"  href="#">
<img src="Images/Close.jpg" alt="X"/></a>
</td>
</tr>
<tr>
<td colspan="3" style="height:1%;"></td>
</tr>
<tr>
<td colspan="3" style="width:100%"> 
<asp:Menu ID="Menu1" Orientation="Horizontal" runat="server" onmenuitemclick="Menu1_MenuItemClick" BorderStyle="None" Font-Size="Medium" ForeColor="Gray" Width="99%" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="6px" Height="30px" Font-Size="Medium" Width="200px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Medium" BorderStyle="None" CssClass="textAlign" Width="200px" />
<Items>
<asp:MenuItem  Text="ERROR INFORMATION" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="MESSAGE INFORMATION" Value="1"></asp:MenuItem>     
<asp:MenuItem Text="" Value="2" Enabled="false"></asp:MenuItem>       
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="6px" Font-Size="Medium" Height="30px" Width="200px" BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
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
<td align="left" style="text-align:left; width:100%; height:25px;" colspan="4">
<asp:Label ID="lblServiceNameValue" runat="server" Font-Bold="True" Font-Size="Medium" ForeColor="#003399"></asp:Label>
</td>
</tr>
<tr><td style="height:1px;" colspan="4"></td></tr>
<tr>
<td align="left" style="width:20%;height:20px">
<asp:label ID="Label3" runat="server" Text="Processing Server:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td align="left" style="text-align:left;width:30%;">
<asp:Label ID="lblServer" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="Gray"></asp:Label>
</td>
<td align="left" style="height:20px;">
<asp:label ID="Label2" runat="server" Text="Instance ID:" Font-Size="Small" ForeColor="#003399">
</asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblInstanceID" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td align="left" style="height:20px;">
<asp:label ID="lblCT" runat="server" Text="Creation Time:" Font-Size="Small" ForeColor="#003399"></asp:label>
</td>
<td align="left" style="text-align:left;">
<asp:Label ID="lblCreationTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
<td align="left" style="width:20%;">
<asp:label ID="Label1" runat="server" Text="Suspend Time:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td align="left" style="text-align:left; width:30%;">
<asp:Label ID="lblSuspendTime" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray"></asp:Label>
</td>
</tr>
<tr>
<td>
<asp:label ID="Label4" runat="server" Text="Error Code:" Font-Size="Small" ForeColor="#003399"/>
</td>
<td>
<asp:Label ID="lblErrorCode" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="gray">
</asp:Label>
</td>
<td></td>
<td></td>
</tr>
<tr><td style="height:4px;" colspan="4"></td></tr>
<tr>
<td align="left" colspan="4" style="height:20px;">
<asp:Label ID="lblErrorDescMessage" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="#003399" Text="Error Description">
</asp:Label>
</td>
</tr>
<tr>
<td colspan="4" style="height:250px; width:100%">
<asp:TextBox ID="txtErrorDetail" runat="server" TextMode="MultiLine" ReadOnly="true" Width="99%" Height="99%" ForeColor="gray"></asp:TextBox>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View2" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:Label Font-Size="Small" Visible="true" ForeColor="#003399" runat="server" Text="Select Message Type"></asp:Label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;">
<asp:DropDownList ID="ddlInstanceData" runat="server"  ForeColor="gray" Width="99%"
AutoPostBack="true" Font-Size="Small" OnSelectedIndexChanged="ddlInstanceData_SelectedIndexChanged">
</asp:DropDownList>
</td>
</tr>
<tr>
<td align="left" style="text-align:left;height:20px;width:20%;">
<asp:label ID="lblMsgID" runat="server" Text="Message ID:" Font-Size="Small" Visible="false" ForeColor="#003399">
</asp:label>
</td>
<td align="left" style="text-align:left;height:20px;width:80%;" >
<asp:Label ID="lblMessageID" runat="server" Font-Bold="True"  Visible="false" Font-Size="Small" ForeColor="gray" ></asp:Label>
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
<asp:TextBox ID="txtDetail" runat="server"   TextMode="MultiLine" ReadOnly="true" ForeColor="Green" Width="99%" Height="99%"></asp:TextBox>
</td>
</tr>
</table>
</asp:View> 
<asp:View ID="View3" runat="server">
<table style="width:100%">
<tr>
<td align="left" style="text-align:left; width:100%;height:100%;">
<div id="contextDIV" style ="height:410px; width:860px; overflow:auto;">
<asp:Label ID="lblConexterror" runat="server" Text="" Font-Size="Small" Visible="false" ForeColor="#003399"></asp:Label>
<asp:GridView ID="grdViewContext" runat="server" CellPadding="6" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewContext_RowDataBound" 
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left"  BorderColor="White" CellSpacing="1" Width="100%" AllowSorting="True" OnSorting="grdViewContext_Sorting" RowStyle-Wrap="True"> 
<AlternatingRowStyle Wrap="true" BackColor="#EFF3FB" Width="80px" />
<EditRowStyle BackColor="White" Wrap="true" />
<EmptyDataRowStyle Wrap="true" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" Font-Size="Smaller" />
<RowStyle Font-Size="Smaller" Wrap="true" BackColor="White" Width="80px" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" ForeColor="White" 
        Wrap="true" BackColor="#43C6DB" />
<SortedAscendingCellStyle Wrap="true" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="true" />
<SortedDescendingCellStyle BackColor="White" Wrap="true" />
<SortedDescendingHeaderStyle Wrap="true" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</asp:View>
</asp:MultiView>
</td>
</tr>
<tr>
<td colspan="3"></td>
</tr>
</table>
</asp:Panel>
</td>
</tr>
<tr><td colspan="2" style="Height: 2px; " bgcolor="White"></td></tr>
<tr>
<td colspan="2">
<asp:Label ID="lblServiceName" runat="server" Font-Bold="True" 
Font-Size="Small" ForeColor="#003399"></asp:Label>
</td>   
</tr>
<tr><td colspan="2" style="Height: 8px;" bgcolor="White"></td></tr>
<tr>
<td colspan="2" style="padding-left:8px;">
<asp:CheckBox ID="chkAll"  onclick="SelectAllCheckboxesSpecific(this)" runat="server" BorderStyle="None" Visible="False" Text="    " 
Width="40px" Height="30px"  />
<asp:Button ID="btnDownloadInstance" runat="server" Text="Download" BorderStyle="None" Enabled="False" Visible="False" Height="30px" Width="80px" onclick="btnDownloadInstance_Click" CssClass="ButtonClass"/>
<asp:Button ID="btnResumeInstance" runat="server" Text="Resume" BorderStyle="None" Enabled="False" Visible="False" onclick="btnResumeInstance_Click" Height="30px" Width="80px" CssClass="ButtonClass" />
<asp:Button ID="btnTerminateInstance" runat="server"  Text="Terminate Instance"   BorderStyle="None" Enabled="False" Visible="False"  Height="30px" Width="130px" CssClass="ButtonClass" />
<asp:Button ID="btnIndividualInstance" runat="server"  Text="Terminate Instance" OnClientClick ="ShowInstanceConfirmationMask();return false;"  BorderStyle="None" Enabled="true"   Height="30px" Width="130px" style="visibility:hidden;" CssClass="ButtonClass" />
</td>
</tr>
<tr><td colspan="2" style="Height: 10px; " bgcolor="White"></td></tr>
<tr>
<td colspan="2">
<div id ="ab"  class="GridDock">
<asp:GridView ID="grdViewInstancesDetails" runat="server" ForeColor="#333333" 
GridLines="None" Visible="False" 
OnRowDataBound = "grdViewInstancesDetails_RowDataBound" 
OnRowCommand="grdViewInstancesDetails_RowCommand" SortExpression=""
DataKeyNames="Instance ID" HorizontalAlign="Left" 
OnPageIndexChanging="grdViewInstancesDetails_PageIndexChanging" OnSorting="grdViewInstancesDetails_Sorting"
CellSpacing="1" CellPadding="6" Width="100%" AllowSorting="True" >
<Columns>
<asp:TemplateField HeaderText="">
<ItemTemplate>
<asp:CheckBox ID="chkDelete" onclick = "Check_Click(this)" runat="server" />
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="View" SortExpression="">
<ItemTemplate>
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View Suspension Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("Instance ID") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
</Columns>
<AlternatingRowStyle BackColor="#EFF3FB" Wrap="False" ForeColor="Black" />
<EditRowStyle Wrap="False" />
<EmptyDataRowStyle Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" Wrap="False"/>
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle Font-Size="Smaller" Wrap="False" BackColor="White" ForeColor="Black" />
<SelectedRowStyle Font-Bold="True" Font-Size="Smaller" 
ForeColor="#333333" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</ContentTemplate>
<Triggers>
<asp:PostBackTrigger ControlID="btnServiceMessage" />
<asp:PostBackTrigger ControlID="btnDownloadInstance" />
</Triggers>
</asp:UpdatePanel>
</td>
</tr>
</table>
</asp:Content>
