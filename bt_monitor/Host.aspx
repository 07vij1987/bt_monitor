<%@ Page Title="Monitor | Hosts" Language="C#" MasterPageFile="~/BizTalkMonitor.Master" AutoEventWireup="true" CodeBehind="Host.aspx.cs" Inherits="bt_monitor.Host" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
.style1
{
height: 26px;
}
</style>
<style type="text/css">
.modal
{
position: fixed;
top: 0;
left: 0;
background-color: black;
z-index: 99;
opacity: 0.8;
filter: alpha(opacity=80);
-moz-opacity: 0.8;
min-height: 100%;
width: 100%;
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
.HeaderFreez
{
   position:relative ;
   top:expression(this.offsetParent.scrollTop);
   z-index: 10;
}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<script src="Scripts/jquery.tablesorter.min.js" type="text/javascript"></script>
<script type = "text/javascript">
    $(document).ready(function () {
        $("#<%=grdViewHostMain.ClientID%>").tablesorter();
    });
    </script>
<script type="text/javascript">
        function ShowProgress() {
            setTimeout(function () {
                var modal = $('<div />');
                modal.addClass("modal");
                $('body').append(modal);
                var loading = $(".loading");
                loading.show();
                var top = Math.max($(window).height() / 2 - loading[0].offsetHeight / 2, 0);
                var left = Math.max($(window).width() / 2 - loading[0].offsetWidth / 2, 0);
                loading.css({ top: top, left: left });
            }, 2);
        }
        $('form').live("submit", function () {
            ShowProgress();
        });
</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("th").attr("align", "left");
    });
</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("th").addClass('rightborder');
    });
    $(document).ready(function () {
        $('#a').addClass('GridDock');
        $('#a').width($('#dvScreenWidth').width());
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
</style>
<style type="text/css">
    .GridDock
    {
        overflow: auto;
        width: 200px;
        height:640px;
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div id="dvScreenWidth" visible="false"></div>
    <table style="padding-left:2px; width:100%; height:100%">
    <tr><td colspan="2" style="Height: 1px; position: absolute;" bgcolor="White"></td></tr>
    <tr><td class="style1">
            &nbsp;</td></tr>
     <tr><td colspan="2" style="Height: 1px; position: absolute;" bgcolor="White"></td></tr>
     <tr>
     <td colspan="2">
            <div id="a">
                <asp:GridView ID="grdViewHostMain" runat="server" CellPadding="7" ForeColor="#333333" 
                GridLines="None" PageSize="8"  
                OnSelectedIndexChanged = "grdViewHostMain_SelectedIndexChanged"
                OnRowDataBound = "grdViewHostMain_RowDataBound" 
                    HorizontalAlign="Left" CellSpacing="1" BorderStyle="None" width="100%">
                <AlternatingRowStyle BackColor="White" />
                <EditRowStyle BackColor="#2461BF" Font-Size="Smaller" />
                <FooterStyle BackColor="#507CD1" Font-Bold="False" ForeColor="White" 
                        Font-Size="Smaller" />
                <HeaderStyle BackColor="White" Font-Bold="False" ForeColor="Gray" 
                HorizontalAlign="Left" Font-Size="Smaller" 
                        Font-Underline="False" BorderColor="#666666" BorderStyle="None" CssClass="HeaderFreez" />
                <PagerStyle BackColor="#99CCFF" ForeColor="White" HorizontalAlign="Center" 
                        Font-Size="Smaller" />
                <RowStyle BackColor="#EFF3FB" Font-Size="Smaller" />
                <SelectedRowStyle Font-Bold="False" ForeColor="#3399FF" 
                Font-Size="Smaller" />
                <SortedAscendingCellStyle BackColor="#F5F7FB" />
                <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                <SortedDescendingCellStyle BackColor="#E9EBEF" />
                <SortedDescendingHeaderStyle BackColor="#4870BE" />
                </asp:GridView>
                <asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
            </div>
            <div class="loading" align="center">
                Processing.... Please wait.<br />
            <br />
            <img src="Images/loading1.gif" alt="" />
            </div>
        </td>
   </tr>
</table>
</asp:Content>
