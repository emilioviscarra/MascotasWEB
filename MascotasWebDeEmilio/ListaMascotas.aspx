<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListaMascotas.aspx.cs" Inherits="MascotasWebDeEmilio.ListaMascotas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <h1>LISTA MASCOTAS</h1>
    <br />
    <div>
        <asp:GridView ID="MascotasGridView" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="MascotasGridView_SelectedIndexChanged" DataKeyNames="MascotaId,DuenoId" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal">
            <Columns>

                <asp:BoundField DataField="DuenoId" HeaderText="DuenoId" SortExpression="DuenoId" Visible="false" />
                <asp:BoundField DataField="MascotaId" HeaderText="MascotaId" SortExpression="MascotaId" Visible="false" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" SortExpression="Nombre" ItemStyle-Width="150px" />
                <asp:BoundField DataField="TipoForDisplay" HeaderText="Tipo" SortExpression="TipoForDisplay" ItemStyle-Width="100px" />
                <asp:BoundField DataField="RazaForDisplay" HeaderText="Raza" SortExpression="RazaForDisplay" ItemStyle-Width="100px" />
                <asp:BoundField DataField="DuenoForDisplay" HeaderText="Dueño" SortExpression="DuenoForDisplay" ItemStyle-Width="250px" />
                <asp:BoundField DataField="EdadForDisplay" HeaderText="Edad" SortExpression="EdadForDisplay" ItemStyle-Width="100px" />
                <asp:CommandField ShowSelectButton="True" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" SelectText="Ver detalles de dueño">
                    <ItemStyle HorizontalAlign="Center" Width="100px"></ItemStyle>
                </asp:CommandField>
            </Columns>
             <EmptyDataTemplate>
                <div align="center">No hay mascotas registradas.</div>
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
