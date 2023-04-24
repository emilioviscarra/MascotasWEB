<%@ Page Title="Registro de dueño" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistroDueno.aspx.cs" Inherits="RegistroDueno" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <h1>REGISTRO DE DUEÑO</h1>
    <br />
    <div>
        <b>NOMBRE:</b>
        <br />
        <asp:TextBox ID="NombreTB" runat="server" Width="250px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="NombreValidator" runat ="server" ControlToValidate="NombreTB" ErrorMessage="El nombre es requerido." ValidationGroup="RegistroDueno" ForeColor="Red"></asp:RequiredFieldValidator>
        <br />

        <b>APELLIDOS:</b>
        <br />
        <asp:TextBox ID="ApellidosTB" runat="server" Width="250px"></asp:TextBox>
        <asp:RequiredFieldValidator ID="ApellidosValidator" runat ="server" ControlToValidate="ApellidosTB" ErrorMessage="Los apellidos son requeridos." ValidationGroup="RegistroDueno" ForeColor="Red"></asp:RequiredFieldValidator>
        <br />

        <b>DIRECCION:</b>
        <br />
        <asp:TextBox ID="DireccionTB" runat="server" Width="250px"></asp:TextBox>
         <asp:RequiredFieldValidator ID="DireccionValidator" runat ="server" ControlToValidate="DireccionTB" ErrorMessage="La dirección es requerida." ValidationGroup="RegistroDueno" ForeColor="Red"></asp:RequiredFieldValidator>
       
        <br />
        <br />
        <asp:Button ID="GuardarDuenoBT" runat="server" Text="Guardar" OnClick="GuardarDuenoBT_Click" ValidationGroup="RegistroDueno" />


        <asp:LinkButton ID="CancelarLinkButton" runat="server" Text="Cancelar" OnClick="CancelarLinkButton_Click"></asp:LinkButton>

        <br />
        <asp:Label ID="MessageLB" runat="server" Font-Bold="True" Visible="False" ForeColor="Red"></asp:Label>
        <br />
    </div>
</asp:Content>
