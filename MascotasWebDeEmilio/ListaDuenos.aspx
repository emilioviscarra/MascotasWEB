<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListaDuenos.aspx.cs" Inherits="MascotasWebDeEmilio.ListaDuenos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <br />
    <br />
    <br />
    <h1>LISTA DUEÑOS</h1>
    <br />
    <div>
        <asp:GridView ID="DuenosGridView" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="DuenosGridView_SelectedIndexChanged" DataKeyNames="DuenoId" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal">
            <Columns>

                <asp:BoundField DataField="DuenoId" HeaderText="DuenoId" SortExpression="DuenoId" Visible="false" />
                <asp:BoundField DataField="Nombres" HeaderText="Nombres" SortExpression="Nombres" ItemStyle-Width="150px" />
                <asp:BoundField DataField="Apellidos" HeaderText="Apellidos" SortExpression="Apellidos" ItemStyle-Width="150px" />
                <asp:BoundField DataField="Direccion" HeaderText="Direccion" SortExpression="Direccion" ItemStyle-Width="350px" />
                <asp:CommandField ShowSelectButton="True" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" SelectText="Ver Mascotas">
                    <ItemStyle HorizontalAlign="Center" Width="100px"></ItemStyle>
                </asp:CommandField>
            </Columns>
            <EmptyDataTemplate>
                <div align="center">No hay dueños registrados.</div>
            </EmptyDataTemplate>

            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />


        </asp:GridView>




    </div>

    <asp:HiddenField ID="SearchParamsHF" runat="server" />



</asp:Content>
