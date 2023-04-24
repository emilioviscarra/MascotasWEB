<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistroMascota.aspx.cs" Inherits="MascotasWebDeEmilio.RegistroMascota" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <br />
    <br />
    <br />
    <h1>REGISTRO MASCOTA</h1>

    <div>
        <b>NOMBRE DEL DUEÑO:</b>
        <div runat="server" id="NombreTextBoxDIV">
            <asp:DropDownList ID="DuenoDDL" runat="server" DataTextField="Nombres" DataValueField="DuenoId"></asp:DropDownList>
            <br />
        </div>

        <div runat="server" id="NombreLabelDIV">
            <b>NOMBRE DE MASCOTA:</b>
            <asp:Label ID="NombreLB" runat="server"></asp:Label>
            <br />
            <asp:TextBox ID="NombreTB" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="NombreValidator" runat ="server" ControlToValidate="NombreTB" ErrorMessage="El nombre es requerido." ValidationGroup="RegistroMascota" ForeColor="Red"></asp:RequiredFieldValidator>
        </div>
        <b>TIPO:</b>

        <br />
        <asp:DropDownList ID="TiposMascotaDDL" runat="server" DataTextField="Nombre" DataValueField="TipoMascotaId" OnSelectedIndexChanged="TiposMascotaDDL_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>        
        <br />

        <b>RAZA:</b>
        <br />
        <asp:DropDownList ID="RazaDDL" runat="server" DataTextField="Nombre" DataValueField="RazaMascotaId"></asp:DropDownList>
        <br />


        <b>EDAD:</b>
        <br />
        <asp:Calendar ID="EdadCalendar" runat="server" BackColor="White" BorderColor="#999999" Caption="Seleccione una fecha" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" SelectedDate="04/22/2023 12:50:09" Width="200px">
            <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
            <NextPrevStyle VerticalAlign="Bottom" />
            <OtherMonthDayStyle ForeColor="#808080" />
            <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
            <SelectorStyle BackColor="#CCCCCC" />
            <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
            <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
            <WeekendDayStyle BackColor="#FFFFCC" />
        </asp:Calendar>
        <br />

        <asp:Button ID="GuardarMascotaBT" runat="server" Text="Guardar" OnClick="GuardarMascotaBT_Click" ValidationGroup="RegistroMascota"  />
        <asp:LinkButton ID="CancelarLinkButton" runat="server" Text="Cancelar" OnClick="CancelarLinkButton_Click"></asp:LinkButton>
        <asp:HiddenField ID="DuenoIDHF" runat="server" />
    </div>
</asp:Content>
