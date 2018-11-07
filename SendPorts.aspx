<%@ Page Title="Monitor | Send Ports" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="SendPorts.aspx.cs" Inherits="BizTalk_Monitor.SendPorts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type = "text/javascript" language="javascript">
function jScript() {
$('#a').width(1);

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width());
});

$("#ContentPlaceHolder1_grdViewSendPorts td:contains('Started')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
});
$("#ContentPlaceHolder1_grdViewSendPorts td:contains('Stopped')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
});
$("#ContentPlaceHolder1_grdViewSendPorts td:contains('Unenlisted')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/UnEnlisted.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Unenlisted</span>";
});
$("th").removeClass('rightborder');
$("th").addClass('rightborder');
$("th").attr("align", "left");
}

function Check_Click(objRef) {
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var grid = document.getElementById("<%= grdViewSendPorts.ClientID %>");

var atleastOneDisabled = false;
var atleastOneEnabled = false;
var alleastOneUnenlisted = false;


for (var j = 0; j < inputList.length; j = j + 1) {
if (inputList[j].type == "checkbox") {
if (inputList[j].checked) {
var cellStatus = grid.rows[j + 1].cells[3].innerHTML;
if (cellStatus == "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>") {
atleastOneDisabled = true;
break;
}
}
}
}

for (var Unen = 0; Unen < inputList.length; Unen = Unen + 1) {
if (inputList[Unen].type == "checkbox") {
if (inputList[Unen].checked) {
var cellStatus = grid.rows[Unen + 1].cells[3].innerHTML;
if (cellStatus == "<img src=\"Images/UnEnlisted.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Unenlisted</span>") {
alleastOneUnenlisted = true;
break;
}
}
}
}

for (var k = 0; k < inputList.length; k = k + 1) {
if (inputList[k].type == "checkbox") {
if (inputList[k].checked) {
var cellStatus = grid.rows[k + 1].cells[3].innerHTML;
if (cellStatus == "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started") {
atleastOneEnabled = true;
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

if (!alleastOneUnenlisted) {
if (atleastOneEnabled && atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnUnenlist.ClientID %>").disabled = false;
document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0";
}
else if (atleastOneEnabled) {

document.getElementById("<%= btnDisable.ClientID %>").disabled = false;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'white';
document.getElementById("<%= btnUnenlist.ClientID %>").disabled = false;
document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "1";
}
else if (atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = false;
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'white';
document.getElementById("<%= btnUnenlist.ClientID %>").disabled = false;
document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "2";

}
else if (!atleastOneEnabled && !atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnUnenlist.ClientID %>").disabled = true;
document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnlist.ClientID %>").disabled = true;
document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0";
}
}
else {
if (!atleastOneEnabled && !atleastOneDisabled) {
document.getElementById("<%= btnEnlist.ClientID %>").disabled = false;
document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'white';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "3";
}
else {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnUnenlist.ClientID %>").disabled = true;
document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnlist.ClientID %>").disabled = true;
document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'gray';
document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value = "0";
}
}

document.getElementById("<%= chkAll.ClientID %>").checked = checked;
}

function SelectAllCheckboxesSpecific(spanChk) {
var IsChecked = spanChk.checked;
var Chk = spanChk;
Parent = document.getElementById("<%= grdViewSendPorts.ClientID %>");
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

function ShowPopup() {
    $('#mask').show();
    $('#<%=pnlpopup.ClientID %>').show();
}
function HidePopup() {
    $('#mask').hide();
    $('#<%=pnlpopup.ClientID %>').hide();
}

function ShowErrorMask() {
    $('#errorMask').show();
    $('#<%=pnlErrorMask.ClientID %>').show();
}

function HideErrorMask() {
    $('#errorMask').hide();
    $('#<%=pnlErrorMask.ClientID %>').hide();
}

$(".btnCloseErrorBox").live('click', function () {
    HideErrorMask();
});
$(".btnClose").live('click', function () {
    HidePopup();
    if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "0") {
        document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnUnenlist.ClientID %>").disabled = true;
        document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnlist.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "1") {
        document.getElementById("<%= btnDisable.ClientID %>").disabled = false;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnUnenlist.ClientID %>").disabled = false;
        document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnlist.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "2") {
        document.getElementById("<%= btnEnable.ClientID %>").disabled = false;
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnUnenlist.ClientID %>").disabled = false;
        document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnlist.ClientID %>").disabled = true;
        document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'gray';
    }
    else if (document.getElementById("<%= hdnCheckBoxChk.ClientID %>").value == "3") {
        document.getElementById("<%= btnEnlist.ClientID %>").disabled = false;
        document.getElementById("<%= btnEnlist.ClientID %>").style.backgroundColor = '#F88017';
        document.getElementById("<%= btnEnlist.ClientID %>").style.color = 'white';
        document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
        document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
        document.getElementById("<%= btnUnenlist.ClientID %>").disabled = true;
        document.getElementById("<%= btnUnenlist.ClientID %>").style.backgroundColor = '';
        document.getElementById("<%= btnUnenlist.ClientID %>").style.color = 'gray';

    }
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
.txtbox
{
border-top-left-radius: 5px;
border-top-right-radius: 5px;
border-bottom-left-radius: 5px;
border-bottom-right-radius: 5px;
border-width:thin;
}
.textAlign
{
text-align:center;
vertical-align:middle;
}
.loading
{
font-family: Arial;
font-size: 10pt;
border: 1px solid #67CFF5;
width: 200px;
height: 100px;
display: none;
position: fixed;
background-color: White;
z-index: 999;
}
.ButtonClass
{
cursor: pointer;
}
.GridDock
{
    overflow: auto;
    width: 200px;
    height:629px;
    padding: 0 0 17px 0;
}
.rightborder
{
    border: 1px white;
    border-style: solid;
    border-right-color: Gray;
    border-bottom-color:Gray;
    border-spacing:none;
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
#errorMask
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
var xPos, yPos;
var prm = Sys.WebForms.PageRequestManager.getInstance();
prm.add_initializeRequest(prm_InitializeRequest);
prm.add_endRequest(prm_EndRequest);

function prm_InitializeRequest(sender, args) {
$get(args._postBackElement.id).disabled = true;
xPos = $get('a').scrollLeft;
yPos = $get('a').scrollTop;

var postBackElement = args.get_postBackElement();
if (postBackElement.id == 'ContentPlaceHolder1_grdViewSendPorts' || postBackElement.id == 'ContentPlaceHolder1_menuProperties') {
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
<asp:HiddenField id="hdnCheckBoxChk" runat="server" Value="0" />
<table style="padding-left:2px;">
<tr><td colspan="2" style="Height: 2px; position: absolute;" bgcolor="White"></td></tr>
<tr><td colspan="2" style="Height: 8px; position: absolute;" bgcolor="White"></td></tr>
<tr>
<td align="left" colspan="2" style="padding-left:8px;">
<asp:CheckBox ID="chkAll"  onclick="SelectAllCheckboxesSpecific(this)" 
runat="server" BorderStyle="None" Visible="False" Text="    " 
Width="40px" Height="30px" />
<asp:Button ID="btnEnable" runat="server" Text="Start" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnEnable_Click" CssClass="ButtonClass" />
<asp:Button ID="btnDisable" runat="server" Text="Stop" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnDisable_Click" CssClass="ButtonClass" />
<asp:Button ID="btnEnlist" runat="server" Text="Enlist" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnEnlist_Click" CssClass="ButtonClass" />
<asp:Button ID="btnUnenlist" runat="server" Text="Unenlist" BorderStyle="None" 
Enabled="False" Visible="False" Width="70px" Height="30px" 
onclick="btnUnenlist_Click" CssClass="ButtonClass" />
<asp:Button ID="btnRefresh" runat="server" Text="Refresh" Width="80px" 
Height="30px" CssClass="ButtonClass" Font-Size="Small" BorderStyle="None" 
BackColor="#F88017" ForeColor="White" onclick="btnRefresh_Click" Visible="False" />
</td>
</tr>
<tr><td colspan="2" style="Height: 5px; position: absolute;" bgcolor="White"></td></tr>
<tr>
<td colspan="2"  style ="height:650px;">
        
<div id="a" class="GridDock">
<asp:GridView ID="grdViewSendPorts" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  AutoGenerateColumns="false" ShowHeaderWhenEmpty="true"
OnRowDataBound = "grdViewSendPorts_RowDataBound" 
OnRowCommand="grdViewSendPorts_RowCommand" OnSorting="grdViewSendPorts_Sorting"
HorizontalAlign="Left" CellSpacing="1" Width="100%" AllowSorting="True">
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
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View Send Port Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("PortName") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
<asp:BoundField DataField="PortName" HeaderText="Port Name" SortExpression="PortName"/>
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
<asp:BoundField DataField="URI" HeaderText="URI" SortExpression="URI"/>
<asp:TemplateField HeaderText="Transport" SortExpression="TransportType">
<HeaderTemplate>
<asp:LinkButton ID="lnkTransport" runat="server"   Text="Transport:" CommandName="SortTransport" ForeColor="Gray"/>
<asp:DropDownList ID="ddlTransport" runat="server" OnSelectedIndexChanged = "ddlTransportChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("TransportType")%>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Sen Handler" SortExpression="SendHandler">
<HeaderTemplate>
<asp:LinkButton ID="lnkReceiveHandler" runat="server"   Text="Send Handler:" CommandName="SortSendHandler" ForeColor="Gray"/>
<asp:DropDownList ID="ddlReceiveHandler" runat="server" OnSelectedIndexChanged = "ddlReceiveHandlerChanged" AutoPostBack = "true" AppendDataBoundItems = "true" CssClass="ddl">
<asp:ListItem Text = "ALL" Value = "ALL"></asp:ListItem>
</asp:DropDownList>
</HeaderTemplate>
<ItemTemplate>
<%# Eval("SendHandler")%>
</ItemTemplate>
</asp:TemplateField>
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
<asp:Panel ID="pnlpopup" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:63%; width:70%;
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
<asp:Menu ID="menuProperties" Orientation="Horizontal" runat="server" onmenuitemclick="menuProperties_MenuItemClick" BorderStyle="None" 
Font-Size="Small" ForeColor="Gray" Width="99%" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="2px" Height="30px" Font-Size="Small" Width="140px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Small" BorderStyle="None" CssClass="textAlign" Width="140px" />
<Items>
<asp:MenuItem  Text="GENERAL" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="BACKUP TRANSPORT" Value="1"></asp:MenuItem>
<asp:MenuItem Text="FILTERS" Value="2"></asp:MenuItem>
<asp:MenuItem Text="TRACKING" Value="3" Enabled="false"></asp:MenuItem>
<asp:MenuItem Text="SEND PIPELINE" Value="4"></asp:MenuItem>
<asp:MenuItem Text="" Value="5" Enabled="false"></asp:MenuItem>      
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="2px" Font-Size="Small" Height="30px" Width="140px" 
BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Small" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="140px" ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" Font-Size="Small" />
</asp:Menu>
<div id ="barDiv" class="topDIVBorder"></div>
</td>
</tr>
</table>
<asp:MultiView ID="MultiView1" ActiveViewIndex="0" runat="server" >
<asp:View ID="View1" runat="server">
<table style="width:100%">
<tr>
<td style="height:1px" ></td>
</tr>
<tr>
<td align="left" valign="top" style="text-align:left; width:15%; height:30px;">
<asp:Label ID ="lblSendportText" runat="server" Text="Name" Font-Size="Small" ForeColor="#003399" />
</td>
<td align="left">
<asp:TextBox ID ="lblSendportName" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray" />
</td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblPortStatus" runat="server" Text="Status" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtPortStatus" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblTransportType" runat="server" Text="Transport Type" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtTransportType" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblURI" runat="server" Text="Transport URI" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtTransportURI" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblHandler" runat="server" Text="Send Handler" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtHandler" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td colspan="2" style="height:1px;"></td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:180px">
<asp:Label ID ="lblOptions" runat="server" Text="Transport Advance Options" Font-Size="Medium" ForeColor="GrayText" />
</td>
<td>
<div id ="Div1" class="topDIVBorder"></div>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:20%;"><asp:Label ID ="Label1" runat="server" Text="Retry Count" Font-Size="Small" ForeColor="#003399" /></td>
<td style="width:25%;"><asp:TextBox ID ="txtRetryCount" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
<td style="width:20%;"><asp:Label ID ="Label4" runat="server" Text="Ordered Delivery" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:CheckBox  ID="chkOrdered" Enabled="false" runat="server" BorderColor="#fafafa" 
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="Label2" runat="server" Text="Retry Interval (minutes)" Font-Size="Small" ForeColor="#003399" /></td>
<td style="width:25%;"><asp:TextBox ID ="txtInterval" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
<td style="width:20%;"><asp:Label ID ="Label5" runat="server" Text="Failed Message Routing" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:CheckBox ID ="chkFMR" Enabled="false" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="Label3" runat="server" Text="Priority" Font-Size="Small" ForeColor="#003399" /></td>
<td style="width:25%;"><asp:TextBox ID ="txtPriority" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
<td style="width:20%;"><asp:Label ID ="Label6" runat="server" Text="Delivery Notification" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:CheckBox ID ="chkDelivery" Enabled="false" runat="server" BorderColor="#fafafa"  Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:30px;">
<asp:Label ID ="Label7" runat="server" Text="Schedule" Font-Size="Medium" ForeColor="GrayText" />
</td>
<td>
<div id ="Div2" class="topDIVBorder"></div>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:20%;"><asp:Label ID ="lblServiceWindowtext" runat="server" Text="Service Window Status" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtServiceWindow" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblServiceStart" runat="server" Text="Start Time" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtServiceStart" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblServiceStop" runat="server" Text="End Time" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtServiceStop" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View2" runat="server" >
<table style="width:100%">
<tr>
<td style="height:3px" ></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBTransportType" runat="server" Text="Transport Type" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBTransportType" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBURI" runat="server" Text="Transport URI" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBTransportURI" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBHandler" runat="server" Text="Send Handler" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBHandler" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="600px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td colspan="2" style="height:2px;"></td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:180px;">
<asp:Label ID ="lblBOptions" runat="server" Text="Transport Advance Options" Font-Size="Medium" ForeColor="GrayText" />
</td>
<td>
<div id ="Div3" class="topDIVBorder"></div>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2" style="height:1px;"></td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:20%;"><asp:Label ID ="lblBRetryCount" runat="server" Text="Retry Count" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBRetryCount" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBRetry" runat="server" Text="Retry Interval (minutes)" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBInterval" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="30px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2" style="height:1px;"></td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:30px;">
<asp:Label ID ="lblBSchedule" runat="server" Text="Schedule" Font-Size="Medium" ForeColor="GrayText" />
</td>
<td>
<div id ="Div4" class="topDIVBorder"></div>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td colspan="2" style="height:1px;"></td>
</tr>
<tr>
<td colspan="2">
<table style="width:100%">
<tr>
<td style="width:20%;"><asp:Label ID ="lblBServiceWindowtext" runat="server" Text="Service Window Status" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBServiceWindow" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBServiceStart" runat="server" Text="Start Time" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBServiceStart" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
<tr>
<td style="width:20%;"><asp:Label ID ="lblBServiceStop" runat="server" Text="End Time" Font-Size="Small" ForeColor="#003399" /></td>
<td><asp:TextBox ID ="txtBServiceStop" ReadOnly="true" runat="server" BorderColor="#fafafa"
CssClass="txtbox"   Width="200px" Height="25px" Font-Size="Small" ForeColor="Gray"/></td>
</tr>
</table>
</td>
</tr>
</table>
</asp:View> 
<asp:View ID="View3" runat="server">
<table style="width:100%;">
<tr>
<td valign="top">
<asp:Label ID ="lblFilters" runat="server" Text="" Font-Size="Medium" ForeColor="#003399" />
</td>
</tr>
</table>
</asp:View> 
<asp:View ID="View4" runat="server">
</asp:View>
<asp:View ID="View5" runat="server">
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
<asp:View ID="View6" runat="server">
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
