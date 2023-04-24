<%@ Page Title="Detalle de dueño" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleDueno.aspx.cs" Inherits="DetalleDueno" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <h1>DETALLES DE DUEÑO</h1>
    <br />
    <div>
        <b>NOMBRE:</b>
        <asp:Label ID="NombreLabel" runat="server" />
        <br />

        <b>APELLIDOS:</b>
        <asp:Label ID="ApellidosLabel" runat="server" />
        <br />

        <b>DIRECCION:</b>
        <asp:Label ID="DireccionLabel" runat="server" />
        <br />
        <asp:Button ID="EditarDuenoBT" runat="server" Text="Editar" OnClick="EditarDuenoBT_Click" />
        
        <asp:LinkButton ID="CancelarLinkButton" runat="server" Text="Volver" OnClick="CancelarLinkButton_Click"></asp:LinkButton>
        <br />
        <br />
        <h2>Mascotas de
        <asp:Label ID="NombreCompletoDuenoLabel" runat="server"></asp:Label></h2>
        <br />
        <asp:LinkButton ID="NuevaMascotaDuenoLinkButton" runat="server" Text="Agregar Mascota" OnClick="NuevaMascotaDuenoLinkButton_Click"></asp:LinkButton>
        <br />
        <asp:GridView ID="MascotasGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="MascotaId,DuenoId" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Horizontal">
            <Columns>

                <asp:BoundField DataField="DuenoId" HeaderText="DuenoId" SortExpression="DuenoId" Visible="false" />
                <asp:BoundField DataField="MascotaId" HeaderText="MascotaId" SortExpression="MascotaId" Visible="false" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" SortExpression="Nombre" ItemStyle-Width="150px" />
                <asp:BoundField DataField="TipoForDisplay" HeaderText="Tipo" SortExpression="TipoForDisplay" ItemStyle-Width="150px" />
                <asp:BoundField DataField="RazaForDisplay" HeaderText="Raza" SortExpression="RazaForDisplay" ItemStyle-Width="150px"/>
                <asp:BoundField DataField="EdadForDisplay" HeaderText="Edad" SortExpression="EdadForDisplay" ItemStyle-Width="150px"/>
            </Columns>


            <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
            <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F7F7F7" />
            <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
            <SortedDescendingCellStyle BackColor="#E5E5E5" />
            <SortedDescendingHeaderStyle BackColor="#242121" />


        </asp:GridView>

        <asp:HiddenField ID="DuenoIdHF" runat="server" />
    </div>
</asp:Content>
