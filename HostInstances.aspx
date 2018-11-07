<%@ Page Title="Monitor | Host Instances" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="HostInstances.aspx.cs" Inherits="BizTalk_Monitor.HostInstances" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
function jScript() {
$(document).ready(function () {
$("th").attr("align", "left");
});

$(document).ready(function () {
$("th").removeClass('rightborder');
$("th").addClass('rightborder');
});

$('#a').width(1);

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width() - 8);
});

$(document).ready(function () {
$("#ContentPlaceHolder1_grdViewHostInstancesMain td:contains('Running')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
});
$("#ContentPlaceHolder1_grdViewHostInstancesMain td:contains('Stopped')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
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

$(document).ready(function () {
$("#ContentPlaceHolder1_grdViewHostInstancesMain td:contains('Running')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
});
$("#ContentPlaceHolder1_grdViewHostInstancesMain td:contains('Stopped')").each(function () {
jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
});
});

$(document).ready(function () {
$("th").attr("align", "left");
});

$(document).ready(function () {
$("th").addClass('rightborder');
});

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width() - 8);
});

function Check_Click(objRef) {
var row = objRef.parentNode.parentNode;
var GridView = row.parentNode;
var inputList = GridView.getElementsByTagName("input");
var grid = document.getElementById("<%= grdViewHostInstancesMain.ClientID %>");

var atleastOneStarted = false;
var atleastOneStopped = false;
var atleastOneEnabled = false;
var atleastOneDisabled = false;
var isIsolatedHost = false;


for (var iStart = 0,s=0; iStart < inputList.length; iStart = iStart+2) {
if (inputList[iStart].type == "checkbox") {
if (inputList[iStart].checked) {
var cellStatus = grid.rows[s + 1].cells[4].innerHTML;
if (cellStatus == "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started") {
atleastOneStarted = true;
break;
}
}
}
s = s + 1;
}

for (var iStop = 0,k=0; iStop < inputList.length; iStop = iStop + 2) {
if (inputList[iStop].type == "checkbox") {
if (inputList[iStop].checked) {
var cellStatus = grid.rows[k + 1].cells[4].innerHTML;
if (cellStatus == "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>") {
atleastOneStopped = true;
break;
}
}
}
k=k+1;
}

for (var isolated = 0, j = 0; isolated < inputList.length; isolated = isolated + 2) {
if (inputList[isolated].type == "checkbox") {
if (inputList[isolated].checked) {
var cellStatus = grid.rows[j + 1].cells[4].innerHTML;
if (cellStatus == "Not Applicable") {
isIsolatedHost = true;
break;
}
}
}
j = j + 1;
}

for (var iEnabled = 1; iEnabled < inputList.length; iEnabled=iEnabled+2) {
if (inputList[iEnabled].type == "checkbox") {
if (inputList[iEnabled - 1].checked) {
if (!inputList[iEnabled].checked) {
atleastOneEnabled = true;
break;
}
}
}
}

for (var iDisabled = 1; iDisabled < inputList.length; iDisabled = iDisabled + 2) {
if (inputList[iDisabled].type == "checkbox") {
if (inputList[iDisabled - 1].checked) {
if (inputList[iDisabled].checked) {
atleastOneDisabled = true;
break;
}
}
}
}

for (var i = 0; i < inputList.length; i=i+2) {
var checked = true;
if (inputList[i].type == "checkbox") {
if (!inputList[i].checked) {
checked = false;
break;
}
}
}

if (!isIsolatedHost) {
if ((atleastOneStarted && atleastOneStopped) || (!atleastOneStarted && !atleastOneStopped)) {
document.getElementById("<%= btnStart.ClientID %>").disabled = true;
document.getElementById("<%= btnStop.ClientID %>").disabled = true;
document.getElementById("<%= btnRestart.ClientID %>").disabled = true;
document.getElementById("<%= btnStart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnStop.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnRestart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnRestart.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnStop.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnStart.ClientID %>").style.color = 'gray';

}
else if (atleastOneStarted) {
document.getElementById("<%= btnStart.ClientID %>").disabled = true;
document.getElementById("<%= btnRestart.ClientID %>").disabled = false;
document.getElementById("<%= btnStop.ClientID %>").disabled = false;
document.getElementById("<%= btnStop.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnStop.ClientID %>").style.color = 'white';
document.getElementById("<%= btnStart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnStart.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnRestart.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnRestart.ClientID %>").style.color = 'white';
            
}
else if (atleastOneStopped) {
document.getElementById("<%= btnStart.ClientID %>").disabled = false;
document.getElementById("<%= btnRestart.ClientID %>").disabled = true;
document.getElementById("<%= btnStop.ClientID %>").disabled = true;
document.getElementById("<%= btnStart.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnStart.ClientID %>").style.color = 'white';
document.getElementById("<%= btnRestart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnRestart.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnStop.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnStop.ClientID %>").style.color = 'gray';
}

if ((atleastOneEnabled && atleastOneDisabled) || (!atleastOneEnabled && !atleastOneDisabled)) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
}
else if (atleastOneDisabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = false;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'white';
}
else if (atleastOneEnabled) {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = false;
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '#F88017';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'white';
}
}
else {
document.getElementById("<%= btnEnable.ClientID %>").disabled = true;
document.getElementById("<%= btnDisable.ClientID %>").disabled = true;
document.getElementById("<%= btnStart.ClientID %>").disabled = true;
document.getElementById("<%= btnStop.ClientID %>").disabled = true;
document.getElementById("<%= btnRestart.ClientID %>").disabled = true;
document.getElementById("<%= btnEnable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnDisable.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnStart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnStop.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnRestart.ClientID %>").style.backgroundColor = '';
document.getElementById("<%= btnEnable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnDisable.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnStart.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnStop.ClientID %>").style.color = 'gray';
document.getElementById("<%= btnRestart.ClientID %>").style.color = 'gray';
}

document.getElementById("<%= chkAll.ClientID %>").checked=checked;
}

function SelectAllCheckboxesSpecific(spanChk) {
var IsChecked = spanChk.checked;
var Chk = spanChk;
Parent = document.getElementById("<%= grdViewHostInstancesMain.ClientID %>");
var items = Parent.getElementsByTagName('input');
var itemCount = 0;

for (i = 0; i < items.length; i=i+2) {

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
</script>
<style type="text/css">
.rightborder
{
    border: 1px white;
    border-style: solid;
    border-right-color: Gray;
    border-bottom-color:Gray;
    border-spacing:none;
}
.ButtonClass
{
    cursor: pointer;
}
.GridDock
{
overflow: auto;
width: 200px;
height:630px;
padding: 0 0 17px 0;
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
 .modal
{
    position: fixed;
    z-index: 999;
    height: 100%;
    width: 100%;
    top: 0;
    left:0;
    background-color: Black;
    filter: alpha(opacity=80);
    opacity: 0.8;
    -moz-opacity: 0.9;
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
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="dvScreenWidth" visible="false"></div>
<asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"/>
<script type="text/javascript">
    var xPos, yPos;
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

        var postBackElement = args.get_postBackElement();
        if (postBackElement.id == 'ContentPlaceHolder1_grdViewHostInstancesMain') {
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
            <br /><span  style="color:Black">Please wait</span>
        </div>
    </div>
</ProgressTemplate>
</asp:UpdateProgress>
<asp:UpdatePanel ID="updatePnlGroup" runat="server" UpdateMode="Conditional" >
<ContentTemplate>
<script type="text/javascript" language="javascript">
    Sys.Application.add_load(jScript);
</script>
<table style="padding-left:2px;">
<tr><td colspan="2" style="Height: 2px; position: absolute;" bgcolor="White"></td></tr>
<tr>
<td class="style1">
<asp:Button ID="btnHostinstances" runat="server" Text="Get Host Instances Information" 
          BorderStyle="None"  Width="237px" onclick="btnHostinstances_Click" 
                Height="20px" BackColor="#F88017" CssClass="ButtonClass" 
                ForeColor="White" /></td>
</tr>
<tr><td colspan="2" style="Height: 8px; position: absolute;" bgcolor="White"></td></tr>
<tr>
    <td align="left" colspan="2" style="padding-left:auto;">
    &nbsp;&nbsp;<asp:CheckBox ID="chkAll"  onclick="SelectAllCheckboxesSpecific(this)" 
            runat="server" BorderStyle="None" Visible="False" Text="    " 
            Width="40px" Height="30px" />
            <asp:Button ID="btnRestart" runat="server" Text="Restart" BorderStyle="None" 
            Enabled="False" Visible="False" Width="70px" Height="30px" 
            onclick="btnRestart_Click" CssClass="ButtonClass" />
        <asp:Button ID="btnStart" runat="server" Text="Start" BorderStyle="None" 
            Enabled="False" Visible="False" Width="70px" Height="30px" 
            onclick="btnStart_Click" CssClass="ButtonClass" />
        <asp:Button ID="btnStop" runat="server" Text="Stop" BorderStyle="None" 
            Enabled="False" Visible="False" Width="70px" Height="30px" 
            onclick="btnStop_Click" CssClass="ButtonClass" />
        <asp:Button ID="btnEnable" runat="server" Text="Enable" BorderStyle="None" 
            Enabled="False" Visible="False" Width="70px" Height="30px" 
            onclick="btnEnable_Click" CssClass="ButtonClass" />
        <asp:Button ID="btnDisable" runat="server" Text="Disable" BorderStyle="None" 
            Enabled="False" Visible="False" Width="70px" Height="30px" 
            onclick="btnDisable_Click" CssClass="ButtonClass" />
    </td>
</tr>
<tr><td colspan="2" style="Height: 5px; position: absolute;" bgcolor="White"></td></tr>
<tr>
        <td colspan="2">
            <div id="a" style="height:620px;">
                <asp:GridView ID="grdViewHostInstancesMain" runat="server" CellPadding="7" ForeColor="#333333" 
                GridLines="None" PageSize="8"  
                    HorizontalAlign="Left" CellSpacing="1" Width="100%"
                    OnRowDataBound = "grdViewHostInstancesMain_RowDataBound" 
                    AllowSorting="True" OnSorting="grdViewHostInstancesMain_Sorting" >
                    <Columns>
                        <asp:TemplateField>
                          <ItemTemplate>
                            <asp:CheckBox ID="chkDelete" onclick = "Check_Click(this)" runat="server"/>
                         </ItemTemplate>
                       </asp:TemplateField>
                </Columns>
                <AlternatingRowStyle BackColor="White" />
                <EditRowStyle BackColor="#2461BF" Font-Size="Smaller" />
                <FooterStyle BackColor="#507CD1" Font-Bold="False" ForeColor="White" 
                        Font-Size="Smaller" />
                <HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
                HorizontalAlign="Left" Font-Size="Smaller" 
                        Font-Underline="False" VerticalAlign="Middle" BorderColor="#666666" 
                        BorderStyle="None" />
                <PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
                        Font-Size="Smaller" />
                <RowStyle BackColor="#EFF3FB" Font-Size="Smaller" HorizontalAlign="Left" 
                        VerticalAlign="Middle" Wrap="True" />
                <SelectedRowStyle Font-Bold="False" ForeColor="#3399FF" 
                Font-Size="Smaller" HorizontalAlign="Left" VerticalAlign="Middle" />
                <SortedAscendingCellStyle BackColor="#F5F7FB" />
                <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                <SortedDescendingCellStyle BackColor="#E9EBEF" />
                <SortedDescendingHeaderStyle BackColor="#4870BE" />

<SortedAscendingCellStyle BackColor="#F5F7FB"></SortedAscendingCellStyle>

<SortedAscendingHeaderStyle BackColor="#6D95E1"></SortedAscendingHeaderStyle>

<SortedDescendingCellStyle BackColor="#E9EBEF"></SortedDescendingCellStyle>

<SortedDescendingHeaderStyle BackColor="#4870BE"></SortedDescendingHeaderStyle>
                </asp:GridView>
                <asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
            </div>
            <div class="loading" align="center">
                Processing.... Please wait.<br />
            <br />
            <img src="Images/loading1.gif" alt="" />
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
        </td>
   </tr>
</table>
</ContentTemplate>
<Triggers>
</Triggers>
</asp:UpdatePanel>
</td>
</tr>
</table>

</asp:Content>
