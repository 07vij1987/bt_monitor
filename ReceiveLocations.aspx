<%@ Page EnableEventValidation="false"  Title="Monitor | Receive Locations" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="ReceiveLocations.aspx.cs" Inherits="BizTalk_Monitor.ReceiveLocations" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<link href="Styles/PageCSS.css" rel="stylesheet" type="text/css" />
<script type = "text/javascript" language="javascript">
var windowStartTime = "";
var windowEndTime = "";

function jScript() {
$('#a').width(1);

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width());
$("th").removeClass('rightborder');
$("th").addClass('rightborder');
$("th").attr("align", "left");

$("#ContentPlaceHolder1_grdViewReceiveLocations td:contains('Enabled')").each(function () {
$(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Enabled";
});
$("#ContentPlaceHolder1_grdViewReceiveLocations td:contains('Disabled')").each(function () {
$(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Disabled</span>";
});
$("#ContentPlaceHolder1_grdViewReceiveLocations td:contains('owYES')").each(function () {
$(this)[0].innerHTML = "Enabled";
});
$("#ContentPlaceHolder1_grdViewReceiveLocations td:contains('owNO')").each(function () {
$(this)[0].innerHTML = "Disabled";
});
});
}

function ShowErrorMask() {
    $('#mask').show();
$('#<%=pnlErrorMask.ClientID %>').show();
}

function HideErrorMask() {
    $('#mask').hide();
$('#<%=pnlErrorMask.ClientID %>').hide();
}

$(".btnCloseErrorBox").live('click', function () {
HideErrorMask();
});

function ShowPopup() {
    $('#mask').show();
    $('#<%=pnlpopup.ClientID %>').show();
}
function HidePopup() {
    $('#mask').hide();
    $('#<%=pnlpopup.ClientID %>').hide();
}
$(".btnClose").live('click', function () {
    HidePopup();
    if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "0") {
        document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "1") {
        document.getElementById("<%= btnDisable.ClientID %>").disabled = false;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray'
    }
    else if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "2") {
        document.getElementById("<%= btnEnable.ClientID %>").disabled = false;
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
    }

    if (document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value == "0") {
        document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value == "1") {
        document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = false;
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'white';

        document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value == "2" || document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value == "3" || document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value == "4") {
        document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'gray';

        document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = false;
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'white';
    }

});

function Check_Click(objRef) {
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var grid = document.getElementById("<%= grdViewReceiveLocations.ClientID %>");

var atleastOneDisabled = false;
var atleastOneEnabled = false;

var moreThanOneWindowDisabled = 0;
var atleastOneWindowDisabled = false;
var atleastOneWindowEnabled = false;

for (var j = 0; j < inputList.length; j = j + 1) {
if (inputList[j].type == "checkbox") {
if (inputList[j].checked) {
var cellStatus = grid.rows[j + 1].cells[3].innerHTML;
if (cellStatus == "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Disabled</span>") {
atleastOneDisabled = true;
break;
}
}
}
}

for (var w = 0; w < inputList.length; w = w + 1) {
if (inputList[w].type == "checkbox") {
if (inputList[w].checked) {
var wCellStatus = grid.rows[w + 1].cells[5].innerHTML;
if (wCellStatus == "Disabled") {
atleastOneWindowDisabled = true;
windowStartTime = grid.rows[w + 1].cells[6].innerHTML;
windowEndTime = grid.rows[w + 1].cells[7].innerHTML;
break;
}
}
}
}

for (var wi = 0; wi < inputList.length; wi = wi + 1) {
if (inputList[wi].type == "checkbox") {
if (inputList[wi].checked) {
var wCellStatus = grid.rows[wi + 1].cells[5].innerHTML;
if (wCellStatus == "Disabled") {
moreThanOneWindowDisabled = moreThanOneWindowDisabled + 1;
}
}
}
}

for (var k = 0; k < inputList.length; k = k + 1) {
if (inputList[k].type == "checkbox") {
if (inputList[k].checked) {
var cellStatus = grid.rows[k + 1].cells[3].innerHTML;
if (cellStatus == "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Enabled") {
atleastOneEnabled = true;
break;
}
}
}
}

for (var wk = 0; wk < inputList.length; wk = wk + 1) {
if (inputList[wk].type == "checkbox") {
if (inputList[wk].checked) {
var wCellStatus = grid.rows[wk + 1].cells[5].innerHTML;
if (wCellStatus == "Enabled") {
atleastOneWindowEnabled = true;
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

if (atleastOneEnabled && atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0";
}
else if (atleastOneEnabled) {

document.getElementById("<%= btnDisable.ClientID %>").disabled = false;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "1";
}
else if (atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = false;
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "2";
}
else if (!atleastOneEnabled && !atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0";
}


if (atleastOneWindowEnabled && atleastOneWindowDisabled) {
document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = true;
document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = true;
document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "0";
}
else if (atleastOneWindowEnabled) {

document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = false;
document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "1";
}
else if (atleastOneWindowDisabled) {
document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = false;
document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "2";

if (moreThanOneWindowDisabled < 2) {
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "3";
}
else {
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "4";
}

}
else if (!atleastOneWindowEnabled && !atleastOneWindowDisabled) {
document.getElementById("<%= btnEnableWindow.ClientID %>").disabled = true;
document.getElementById("<%= btnDisableWindow.ClientID %>").disabled = true;
document.getElementById("<%= btnDisableWindow.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisableWindow.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnableWindow.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnableWindow.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChkW.ClientID %>").value = "0";
}


document.getElementById("<%= chkAll.ClientID %>").checked = checked;
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

function SelectAllCheckboxesSpecific(spanChk) {
var IsChecked = spanChk.checked;
var Chk = spanChk;
Parent = document.getElementById("<%= grdViewReceiveLocations.ClientID %>");
var items = Parent.getElementsByTagName('input');
var itemCount = 0;

for (var chkcount = 0; chkcount < items.length; chkcount++) {

if (items[chkcount].id != Chk && items[chkcount].type == "checkbox") {

if (items[chkcount].checked != IsChecked) {
items[chkcount].click();
}
}
}
}

</script>
<style type="text/css">
.GridDock
{
overflow: auto;
width: 200px;
height:595px;
padding: 0 0 17px 0;
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="dvScreenWidth" visible="false"></div>
<asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"/>
<script type="text/javascript">
var xPos, yPos;
var prm = Sys.WebForms.PageRequestManager.getInstance();
prm.add_initializeRequest(prm_InitializeRequest);
prm.add_endRequest(prm_EndRequest);

function prm_InitializeRequest(sender, args) {
$get(args._postBackElement.id).disabled = true;
xPos = $get('a').scrollLeft;
yPos = $get('a').scrollTop;

var postBackElement = args.get_postBackElement();
if (postBackElement.id == 'ContentPlaceHolder1_grdViewReceiveLocations' || postBackElement.id == 'ContentPlaceHolder1_menuProperties') {
$get('ContentPlaceHolder1_UpdateProgress1').style.display = 'none';
var divloading = $get('divModal');
divloading.style.display = 'none';
}
else {
var panelProg = $get('divModal');
panelProg.style.display = '';
}
}

function prm_EndRequest(sender, args) {
var panelProg = $get('divModal');
panelProg.style.display = 'none';
$get('a').scrollLeft = xPos;
$get('a').scrollTop = yPos;
}
</script>
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
<asp:HiddenField id="txtHH" runat="server" />
<asp:HiddenField id="txtMM" runat="server" />
<asp:HiddenField id="txtSS" runat="server" />
<asp:HiddenField id="txtHHE" runat="server" />
<asp:HiddenField id="txtMME" runat="server" />
<asp:HiddenField id="txtSSE" runat="server" />
<asp:HiddenField id="hdnCheckBoxChk" runat="server" Value="0" />
<asp:HiddenField id="hdnCheckBoxChkW" runat="server" Value="0" />
<asp:HiddenField id="hdnScrollPosition" runat="server" Value="" />
<table style="padding-left:2px;">
<tr><td colspan="2" style="Height: 5px; position: absolute;" bgcolor="White"></td></tr>
<tr>
<td align="left"  style="padding-left:8px;width:540px;height:50px; vertical-align:middle">
<asp:CheckBox ID="chkAll"  onclick="SelectAllCheckboxesSpecific(this)" 
runat="server" BorderStyle="None" Visible="False" Text="    " 
Width="40px" Height="30px" />
<asp:Button ID="btnEnable" runat="server" Text="Enable" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnEnable_Click" Font-Bold="False" Font-Size="Small" CssClass="ButtonClass" />
<asp:Button ID="btnDisable" runat="server" Text="Disable" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnDisable_Click" Font-Bold="False" Font-Size="Small" CssClass="ButtonClass" />
<asp:Button ID="btnDisableWindow" runat="server" Text="Disable Window" BorderStyle="None" 
Enabled="False" Visible="False" Width="120px" Height="30px" Font-Bold="False" 
Font-Size="Small" onclick="btnDisableWindow_Click" CssClass="ButtonClass"  />
<asp:Button ID="btnEnableWindow" runat="server" Text="Enable Window" BorderStyle="None" 
Enabled="False" Visible="False" Width="120px" Height="30px" Font-Bold="False" 
Font-Size="Small" onclick="btnEnableWindow_Click" CssClass="ButtonClass" />
<asp:Button ID="btnRefresh" runat="server" Text="Refresh" Width="80px" 
        Height="30px" CssClass="ButtonClass" Font-Size="Small" BorderStyle="None" 
BackColor="#F88017" ForeColor="White" onclick="btnRefresh_Click" Visible="False" />
</td>
<td align="left" style="height:50px;" >
<%--<asp:Panel ID="pnlMain" runat="server"
GroupingText="Service Window (hh:mm:ss)"  Wrap="false" width="35%" 
ForeColor="Gray"  Font-Size="Small" BorderColor="Gray" style="visibility:hidden;">
<table style="width:50%;height:100%">
<tr>
<td style="vertical-align:top;width:20px;">
<asp:Label ID="lblFrom" runat="server" Text="Start Time:" Font-Size="Small" ForeColor="Gray" style="visibility:hidden;" ></asp:Label>
<asp:DropDownList ID="drpdownHH" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedHH()">
</asp:DropDownList>
<asp:DropDownList ID="drpdownMM" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedMM()">
<asp:ListItem>MM</asp:ListItem>
</asp:DropDownList>
<asp:DropDownList ID="drpdownSS" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedSS()">
<asp:ListItem>SS</asp:ListItem>
</asp:DropDownList>
</td>
</tr>
<tr>
<td style="vertical-align:top;width:20px;">
<asp:Label ID="lblTo" runat="server" Text="Stop Time:" Font-Size="Small" style="visibility:hidden;" ForeColor="Gray"></asp:Label>
<asp:DropDownList ID="drpdownHHE" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedHHE()">
</asp:DropDownList>
<asp:DropDownList ID="drpdownMME" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedMME()">
</asp:DropDownList>
<asp:DropDownList ID="drpdownSSE" runat="server" Font-Size="X-Small"  style="visibility:hidden;" onchange ="SelectedIndexChangedSSE()">
</asp:DropDownList>
</td>
</tr>
</table>
</asp:Panel>  --%>
</td>
</tr>
<tr>
<td colspan="2">
<div id="a" class="GridDock"">
<asp:GridView ID="grdViewReceiveLocations" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  AutoGenerateColumns="false" ShowHeaderWhenEmpty="true"
OnRowDataBound = "grdViewReceiveLocations_RowDataBound" 
OnRowCommand="grdViewReceiveLocations_RowCommand" 
HorizontalAlign="Left" CellSpacing="1" Width="100%" AllowSorting="True" OnSorting="grdViewReceiveLocations_Sorting">
<SortedAscendingCellStyle BackColor="#F5F7FB"></SortedAscendingCellStyle>
<SortedAscendingHeaderStyle BackColor="#6D95E1"></SortedAscendingHeaderStyle>
<SortedDescendingCellStyle BackColor="#E9EBEF"></SortedDescendingCellStyle>
<SortedDescendingHeaderStyle BackColor="#4870BE"></SortedDescendingHeaderStyle>
<AlternatingRowStyle BackColor="White" Wrap="False" />
<Columns>
<asp:TemplateField>
<ItemTemplate>
<asp:CheckBox ID="chkDelete" onclick = "Check_Click(this)" runat="server"/>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="View" SortExpression="">
<ItemTemplate>
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View Receive Location Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("LocationName") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
<asp:BoundField DataField="LocationName" HeaderText="Location Name" SortExpression="LocationName"/>
<asp:TemplateField HeaderText="Status" SortExpression="Status">
<HeaderTemplate>
<asp:LinkButton ID="lnkStatus" runat="server"   Text="Status:" CommandName="SortStatus" ForeColor="Gray"/>
<asp:DropDownList ID="ddlStatus" runat="server" OnSelectedIndexChanged = "ddlStatusChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("Status")%>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Transport" SortExpression="Transport">
<HeaderTemplate>
<asp:LinkButton ID="lnkTransport" runat="server"   Text="Transport:" CommandName="SortTransport" ForeColor="Gray"/>
<asp:DropDownList ID="ddlTransport" runat="server" OnSelectedIndexChanged = "ddlTransportChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("Transport")%>
</ItemTemplate>
</asp:TemplateField>
<asp:BoundField DataField="ServiceWindow" HeaderText="Service Window" SortExpression="ServiceWindow"/>
<asp:BoundField DataField="ServiceWindowStartTime" HeaderText="Window Start Time" SortExpression="ServiceWindowStartTime"/>
<asp:BoundField DataField="ServiceWindowEndTime" HeaderText="Window End Time" SortExpression="ServiceWindowEndTime"/>
<asp:BoundField DataField="URI" HeaderText="Location URI" SortExpression="URI"/>
<asp:TemplateField HeaderText="Application Name" SortExpression="ApplicationName">
<HeaderTemplate>
<asp:LinkButton ID="lnkApplicationName" runat="server"   Text="Application Name:" CommandName="SortApplicationName" ForeColor="Gray"/>
<asp:DropDownList ID="ddlApplicationName" runat="server" OnSelectedIndexChanged = "ddlApplicationNameChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("ApplicationName")%>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Port Name" SortExpression="PortName">
<HeaderTemplate>
<asp:LinkButton ID="lnkPortName" runat="server"   Text="Port Name:" CommandName="SortPortName" ForeColor="Gray"/>
<asp:DropDownList ID="ddlPortName" runat="server" OnSelectedIndexChanged = "ddlPortNameChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("PortName")%>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Receive Handler" SortExpression="ReceiveHandler">
<HeaderTemplate>
<asp:LinkButton ID="lnkReceiveHandler" runat="server"   Text="Receive Handler:" CommandName="SortReceiveHandler" ForeColor="Gray"/>
<asp:DropDownList ID="ddlReceiveHandler" runat="server" OnSelectedIndexChanged = "ddlReceiveHandlerChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("ReceiveHandler")%>
</ItemTemplate>
</asp:TemplateField>
</Columns>
<EditRowStyle BackColor="#2461BF" Font-Size="Smaller" Wrap="False" />
<EmptyDataRowStyle Wrap="False" />
<FooterStyle BackColor="#507CD1" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
HorizontalAlign="Left" Font-Size="Smaller" 
Font-Underline="False" VerticalAlign="Middle" BorderColor="#666666" 
BorderStyle="None" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" HorizontalAlign="Left" 
VerticalAlign="Middle" Wrap="False" />
<SelectedRowStyle Font-Bold="False" ForeColor="#3399FF" 
Font-Size="Smaller" HorizontalAlign="Left" VerticalAlign="Middle" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
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
<div id="mask"></div>
<asp:Panel ID="pnlpopup" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:60%; width:70%;
left: auto; top: 15%; border: outset 2px gray;padding:5px;display:none">
<table style="width: 100%; height: 60px;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td  style="height:25px; width: 100%;padding:3px;" align="left" valign="middle">
<asp:Label ID="lblLocationNTypeName" runat="server" Font-Bold="True" Font-Size="Medium"  ForeColor="White"></asp:Label>
<a id="closebtn" style="color:#33CCFF; float: right;text-decoration:none" class="btnClose"  href="#">
<img src="Images/Close.jpg" alt="X"/></a>
</td>
</tr>
<tr><td style="height:1px"></td></tr>
<tr>
<td  valign="top" style="width:100%"> 
<asp:Menu ID="menuProperties" Orientation="Horizontal" runat="server" onmenuitemclick="menuProperties_MenuItemClick" BorderStyle="None" Font-Size="Medium" ForeColor="Gray" Width="99%" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="6px" Height="30px" Font-Size="Medium" Width="140px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Medium" BorderStyle="None" CssClass="textAlign" Width="140px" />
<Items>
<asp:MenuItem  Text="GENERAL" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="SCHEDULE" Value="1"></asp:MenuItem>
<asp:MenuItem Text="RECEIVE PIPELINE" Value="2"></asp:MenuItem>
<asp:MenuItem Text="" Value="3" Enabled="false"></asp:MenuItem>                 
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="8px" Font-Size="Medium" Height="30px" Width="140px" BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Medium" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="140px" ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" Font-Size="Medium" />
</asp:Menu>
<div id ="barDiv" class="topDIVBorder"></div>
</td>
</tr>
</table>
<asp:MultiView ID="MultiView1" ActiveViewIndex="0" runat="server" >
<asp:View ID="View1" runat="server">
<table style="width:100%">
<tr>
<td style="height:3px" ></td>
</tr>
<tr>
<td align="left" valign="top" style="text-align:left; width:15%; height:30px;">
<asp:Label ID ="lblRecvLocationNameText" runat="server" Text="Name" Font-Size="Small" ForeColor="#003399" />
</td>
<td align="left">
<asp:TextBox ID ="lblRecvLocationName" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray" />
</td>
</tr>
<tr>
<td><asp:Label ID ="lblReceivePortTxt" runat="server" Text="Receive Port" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtReceivePort" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td><asp:Label ID ="lblLocationStatus" runat="server" Text="Status" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtLocationStatus" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td><asp:Label ID ="lblTransportType" runat="server" Text="Transport Type" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtTransportType" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td><asp:Label ID ="lblURI" runat="server" Text="Transport URI" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtTransportURI" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td><asp:Label ID ="lblHandler" runat="server" Text="Receive Handler" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtHandler" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</asp:View>
<asp:View ID="View2" runat="server" >
<table style="width:100%;">
<tr>
<td style="height:3px" ></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblServiceWindowtext" runat="server" Text="Service Window Status" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtServiceWindow" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblServiceStart" runat="server" Text="Service Start Time" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtServiceStart" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblServiceStop" runat="server" Text="Service Stop Time" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtServiceStop" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</asp:View> 
<asp:View ID="View3" runat="server">
<table style="width:100%;">
<tr>
<td style="height:3px" ></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblReceivePipeline" runat="server" Text="Receive Pipeline" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtReceivePipeline" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblFullyQualifiedName" runat="server" Text="Fully Qualified Name" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtFullyQualifiedName" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</asp:View> 
<asp:View ID="View4" runat="server">
<table style="width:100%;">
<tr>
<td style="height:3px" ></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblSendpipeline" runat="server" Text="Send Pipeline" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtSendpipeline" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td valign="top"><asp:Label ID ="lblFullyQualifiedSendName" runat="server" Text="Fully Qualified Name" Font-Size="Small" ForeColor="#003399" /></td>
<td valign="top"><asp:TextBox ID ="txtFullyQualifiedSendName" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</asp:View>
</asp:MultiView>
</asp:Panel>
</td>
</tr>
</table>
</ContentTemplate>
<Triggers>
</Triggers>
</asp:UpdatePanel>
</asp:Content>
