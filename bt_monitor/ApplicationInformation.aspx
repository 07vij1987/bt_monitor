<%@ Page EnableEventValidation="false" Title="Monitor | Applications" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="ApplicationInformation.aspx.cs" Inherits="bt_monitor.ApplicationInformation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="Scripts/jquery.tablesorter.min.js" type="text/javascript"></script>
<script type="text/javascript" language="javascript">
function ShowPopup() {
    $("#ContentPlaceHolder1_grdViewSP td:contains('Started')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
    });
    $("#ContentPlaceHolder1_grdViewSP td:contains('Stopped')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
    });
    $("#ContentPlaceHolder1_grdViewSP td:contains('Unenlisted')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/UnEnlisted.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Unenlisted</span>";
    });
    $("#ContentPlaceHolder1_grdViewRC td:contains('Enabled')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
    });
    $("#ContentPlaceHolder1_grdViewRC td:contains('Disabled')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
    });
    $("#ContentPlaceHolder1_grdViewODX td:contains('Started')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
    });
    $("#ContentPlaceHolder1_grdViewODX td:contains('Stopped')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/STOPFinal.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Stopped</span>";
    });
    $("#ContentPlaceHolder1_grdViewODX td:contains('Unenlisted')").each(function () {
        jQuery(this)[0].innerHTML = "<img src=\"Images/UnEnlisted.jpg\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Unenlisted</span>";
    });
$('#maskapp').show();
$('#<%=pnlpopupapp.ClientID %>').show();
}

function HidePopup() {
$('#maskapp').hide();
$('#<%=pnlpopupapp.ClientID %>').hide();
}
$(".btnClose").live('click', function () {
HidePopup();
});
</script>
<script type="text/javascript">
function NoCheckMouseEvents(objRef, evt) {
if (evt.type == "mouseover") {
objRef.style.backgroundColor = "#CCFFFF";
}
else if (evt.type == "mouseout") {
if (objRef.rowIndex % 2 == 0) {
//Alternating Row Color
objRef.style.backgroundColor = "#EFF3FB";
}
else {
objRef.style.backgroundColor = "white";
}
}

objRef.style.color = "#000000";
}
</script>
<script type="text/javascript" language="javascript">
$(document).ready(function () {
$("th").addClass('rightborder');
$('#a').addClass('GridDock');
$('#a').width($('#dvScreenWidth').width());
$("th").attr("align", "left");
});

function jScript() {
$('#a').width(1);

$(document).ready(function () {
$('#a').width($('#dvScreenWidth').width());
$("th").removeClass('rightborder');
$("th").addClass('rightborder');
$("th").attr("align", "left");
});

$("#ContentPlaceHolder1_grdAppInfo td:contains('Complete')").each(function () {
    $(this)[0].innerHTML = "<img src=\"Images/RUNFinal.jpg\">&nbsp;&nbsp;&nbsp;Started";
});
$("#ContentPlaceHolder1_grdAppInfo td:contains('Partail')").each(function () {
    $(this)[0].innerHTML = "<img src=\"Images/Partail.png\"><span style=\"color: gray;\">&nbsp;&nbsp;&nbsp;Partailly Started</span>";
});
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
.topDIVBorder
{
border: 2px white;
border-style: solid;
border-top-color:#E8E8E8;
    
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
.GridDock
{
overflow: auto;
width: 200px;
height:629px;
padding: 0 0 17px 0;
} 
.red
{ 
border-radius: 8px; 
width: 22px;
height: 22px;
background: red;
text-align : center;
vertical-align: middle;
} 
.gray
{ 
border-radius: 5px; 
width: 20px;
height: 20px;
text-align : center;
}
</style>
<style type="text/css">
#maskapp
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
        if (postBackElement.id == 'ContentPlaceHolder1_grdAppInfo' || postBackElement.id == 'ContentPlaceHolder1_menuArtifacts') {
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
<table style="padding-left:2px;">
<tr>
<td colspan="2" style="Height: 1px; position: absolute;" bgcolor="White"></td>
</tr>
<tr>
<td colspan="2" style="Height: 1px; position: absolute;" bgcolor="White"></td>
</tr>
<tr>
<td colspan="2">
<div id="a" class="GridDock">
<asp:GridView ID="grdAppInfo" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"   AutoGenerateColumns="false" ShowHeaderWhenEmpty="true"
OnRowDataBound = "grdAppInfo_RowDataBound" 
OnRowCommand="grdAppInfo_RowCommand"
OnSorting="grdAppInfo_Sorting"
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" Width="100%" AlternatingRowStyle-BackColor="#EFF3FB" AllowSorting="true">
<AlternatingRowStyle BackColor="White" ForeColor="Black" />
<Columns>
<asp:TemplateField HeaderText="View" SortExpression="">
<ItemTemplate>
<asp:LinkButton ID="LinkButtonEdit" runat="server" ToolTip="View App Details" CommandName="ShowPopup" 
CommandArgument='<%#Eval("AppName") %>'><img src="Images/lookup.jpg" alt="view" /></asp:LinkButton>
</ItemTemplate>
</asp:TemplateField>
<asp:BoundField DataField="AppName" HeaderText="Application Name" SortExpression="AppName"/>
<asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status"/>
<asp:TemplateField HeaderText="Suspension Count" SortExpression="SuspensionCount" ItemStyle-HorizontalAlign ="Center">
<ItemTemplate>
<asp:Label ID="lblSuspensionCount" runat="server"  Text ='<%#Eval("SuspensionCount")%>' Width ="35px" ForeColor="White" Font-Italic="true" Font-Bold ="true"></asp:Label>
</ItemTemplate>
</asp:TemplateField>
</Columns>
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" 
ForeColor="Black" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" 
ForeColor="#0066FF"  Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF"  Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
<asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
</div>
<div id="maskapp"></div>
<asp:Panel ID="pnlpopupapp" runat="server"  BackColor="White"  Style="z-index:111;background-color: White; position: absolute;  height:60%; width:70%;
left: auto; top: 15%; border: outset 2px gray;padding:5x;display:none">
<table width="100%" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="5">
<tr style="background-color: #33CCFF; color: #FFFFFF;">
<td  style="height:30px; width: 100%;font-size: 1.2em;padding:3px;" align="left" valign="middle">
<asp:Label ID="lblAppName" runat="server" Font-Bold="True"  ForeColor="White"></asp:Label>
<a id="closebtn" style="color:#33CCFF; float: right;text-decoration:none" class="btnClose"  href="#"><img src="Images/Close.jpg" alt="X"/></a>
</td>
</tr>
<tr>
<td  style="height:5px;"></td>
</tr>
<tr>
<td valign ="top" style="height:35px;" >
<div id="divArtifacts" style ="height:auto; width:auto; overflow:auto;">                  
<asp:Menu ID="menuArtifacts" Orientation="Horizontal" runat="server" onmenuitemclick="menuArtifacts_MenuItemClick" BorderStyle="None" 
Font-Size="Small" ForeColor="Gray" Width="99%" >
<DynamicMenuItemStyle BackColor="White"  BorderStyle="None" HorizontalPadding="2px" Height="30px" Font-Size="Small" Width="140px" CssClass="textAlign"/>
<DynamicMenuStyle BorderStyle="None" CssClass="textAlign" />
<DynamicSelectedStyle  Font-Size="Small" BorderStyle="None" CssClass="textAlign" Width="140px" />
<Items>
<asp:MenuItem  Text="RECEIVE PORTS" Value="0" Selected="true"></asp:MenuItem>
<asp:MenuItem Text="RECEIVE LOCATIONS" Value="1"></asp:MenuItem>
<asp:MenuItem Text="SEND PORTS" Value="2"></asp:MenuItem>
<asp:MenuItem Text="ORCHESTRATIONS" Value="3" ></asp:MenuItem> 
</Items>
<StaticMenuItemStyle  BorderStyle="None" HorizontalPadding="2px" Font-Size="Small" Height="30px" Width="140px" 
BackColor="White" ForeColor="Gray" CssClass="textAlign"/>
<StaticMenuStyle Font-Size="Small" BorderStyle="None" CssClass="textAlign"/>
<StaticSelectedStyle  Height="30px" Width="140px" ForeColor="#336699"  CssClass="textAlign" BackColor="#E8E8E8" Font-Size="Small" />
</asp:Menu>
<div id ="barDiv" class="topDIVBorder"></div>
<asp:MultiView ID="MultiView1" ActiveViewIndex="0" runat="server" >
<asp:View ID="View1" runat="server">
<table style="width:100%">
<tr>
<td style ="height:410px; width:100%;" valign ="top">
<div id="divArtifactInfo" style ="height:390px; width:850px; overflow:auto;">
<asp:GridView ID="grdViewRP" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewArtifactsInfo_RowDataBound" 
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" AutoGenerateColumns = "true">
<AlternatingRowStyle BackColor="White" Wrap="False" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" 
ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View2" runat="server">
<table style="width:100%">
<tr>
<td style ="height:410px; width:100%;" valign ="top">
<div id="div1" style ="height:390px; width:850px; overflow:auto;">
<asp:GridView ID="grdViewRC" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewArtifactsInfo_RowDataBound" 
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" AutoGenerateColumns = "true">
<AlternatingRowStyle BackColor="White" Wrap="False" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" 
ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View3" runat="server">
<table style="width:100%">
<tr>
<td style ="height:410px; width:100%;" valign ="top">
<div id="div2" style ="height:390px; width:850px; overflow:auto;">
<asp:GridView ID="grdViewSP" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewArtifactsInfo_RowDataBound" 
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" AutoGenerateColumns = "true">
<AlternatingRowStyle BackColor="White" Wrap="False" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" 
ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</asp:View>
<asp:View ID="View4" runat="server">
<table style="width:100%">
<tr>
<td style ="height:410px; width:100%;" valign ="top">
<div id="div3" style ="height:390px; width:850px; overflow:auto;">
<asp:GridView ID="grdViewODX" runat="server" CellPadding="7" ForeColor="#333333" 
GridLines="None" PageSize="8"  
OnRowDataBound = "grdViewArtifactsInfo_RowDataBound" 
HorizontalAlign="Left" BorderStyle="None" 
CaptionAlign="Left" BackColor="White" 
HeaderStyle-HorizontalAlign="Left" BorderColor="White" CellSpacing="1" AutoGenerateColumns = "true">
<AlternatingRowStyle BackColor="White" Wrap="False" />
<EditRowStyle BackColor="#EFF3FB" Wrap="False" />
<FooterStyle BackColor="#99CCFF" Font-Bold="False" ForeColor="White" 
Font-Size="Smaller" />
<HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
Font-Size="Smaller" Font-Underline="False" BorderColor="#666666" 
BorderStyle="Solid" Wrap="False" />
<PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
Font-Size="Smaller" />
<RowStyle BackColor="#EFF3FB" Font-Size="Smaller" Wrap="False" />
<SelectedRowStyle Font-Bold="False" Font-Size="Smaller" 
ForeColor="#0066FF" Wrap="False" />
<SortedAscendingCellStyle BackColor="#F5F7FB" Wrap="False" />
<SortedAscendingHeaderStyle BackColor="#6D95E1" Wrap="False" />
<SortedDescendingCellStyle BackColor="#E9EBEF" Wrap="False" />
<SortedDescendingHeaderStyle BackColor="#4870BE" Wrap="False" />
</asp:GridView>
</div>
</td>
</tr>
</table>
</asp:View>
</asp:MultiView>
</div>
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
</asp:Content>
