USE [master]
GO

/* NOTA: se debe reemplazar el directorio C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA */

/****** Object:  Database [MASCOTASWEBDB]    Script Date: 24/4/2023 13:20:53 ******/
CREATE DATABASE [MASCOTASWEBDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MASCOTASWEBDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\MASCOTASWEBDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MASCOTASWEBDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\MASCOTASWEBDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MASCOTASWEBDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [MASCOTASWEBDB] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ARITHABORT OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [MASCOTASWEBDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [MASCOTASWEBDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET  DISABLE_BROKER 
GO

ALTER DATABASE [MASCOTASWEBDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [MASCOTASWEBDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [MASCOTASWEBDB] SET  MULTI_USER 
GO

ALTER DATABASE [MASCOTASWEBDB] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [MASCOTASWEBDB] SET DB_CHAINING OFF 
GO

ALTER DATABASE [MASCOTASWEBDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [MASCOTASWEBDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [MASCOTASWEBDB] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [MASCOTASWEBDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [MASCOTASWEBDB] SET QUERY_STORE = OFF
GO

ALTER DATABASE [MASCOTASWEBDB] SET  READ_WRITE 
GO


--****************************************************************************************************************************************************


USE [MASCOTASWEBDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_DUE_GetDuenosSearch]    Script Date: 20/4/2023 14:59:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DUE_GetDuenosSearch]
	@varSearchParams AS VARCHAR(250)
AS
BEGIN

	IF(@varSearchParams IS NULL)
		SELECT @varSearchParams = ''
		

	SELECT DISTINCT [due].[duenoId] AS duenoId
		  ,[due].[nombre]
		  ,[due].[apellidos]
		  ,[due].[nombre]+' '+[due].[apellidos] AS [nombreCompleto]
		  ,[due].[direccion]
		  ,0 AS cantidadMascotas
	  FROM [dbo].[Dueno] [due]
	  LEFT OUTER JOIN [dbo].[Mascota] [mas] ON ([mas].[duenoId] = [due].[duenoId])
	  
	  WHERE
	  CASE @varSearchParams 
			WHEN '' THEN 1
			ELSE
				CASE WHEN
					[due].[nombre] LIKE '%'+@varSearchParams+'%' OR
					[due].[apellidos] LIKE '%'+@varSearchParams+'%' OR
					[mas].[nombre] LIKE '%'+@varSearchParams+'%'					
				THEN 1 ELSE 0 END
		END  = 1
	ORDER BY [due].[nombre] DESC

END
GO


--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_DUE_InsertDueno]    Script Date: 20/4/2023 15:10:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author: Emilio Viscarra Lujan
-- Create date: 20/04/2023
-- Description: Inserta un registro de Dueño de mascota
-- =============================================
CREATE PROCEDURE [dbo].[usp_DUE_InsertDueno]
	@varNombre				VARCHAR(250),
	@varApellidos			VARCHAR(250),
	@varDireccion			VARCHAR(1000),	
	@intObjectId			INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		SAVE TRANSACTION InsertDueno;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;

	BEGIN TRY

		BEGIN

		INSERT INTO [dbo].[Dueno]
					   ([nombre]
					   ,[apellidos]
					   ,[direccion])
				 VALUES
					   (@varNombre,
						@varApellidos,
						@varDireccion)
												
			SET @intObjectId = SCOPE_IDENTITY()
									
		END

		-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos determinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1 
				ROLLBACK TRANSACTION InsertDueno;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH	

END
GO

--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_DUE_UpdateDueno]    Script Date: 20/4/2023 15:18:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author: Emilio Viscarra Lujan
-- Create date: 20/04/2023
-- Description: Actualiza el registro de Dueño de mascota
-- =============================================
CREATE PROCEDURE [dbo].[usp_DUE_UpdateDueno]
	@intObjectId			INT,
	@varNombre				VARCHAR(250),
	@varApellidos			VARCHAR(250),
	@varDireccion			VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	

BEGIN
			UPDATE [dbo].[Dueno]
			   SET [nombre] = @varNombre
				  ,[apellidos] = @varApellidos
				  ,[direccion] = @varDireccion
			 WHERE [duenoID] = @intObjectId
		END
	

END

GO



--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_DUE_GetDuenoDetails]    Script Date: 20/4/2023 15:29:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[usp_DUE_GetDuenoDetails]
	@intObjectID INT
AS
BEGIN

	
		
	
	BEGIN
		SELECT [due].[duenoId] AS duenoId
		  ,[due].[nombre]
		  ,[due].[apellidos]
		  ,[due].[nombre]+' '+[due].[apellidos] AS [nombreCompleto]
		  ,[due].[direccion]
		  ,0 AS cantidadMascotas
	  FROM [dbo].[Dueno] [due]
			WHERE [due].[duenoId] = @intObjectID
	END
	
	

END
GO




--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_DUE_DeleteDueno]    Script Date: 20/4/2023 15:10:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author: Emilio Viscarra Lujan
-- Create date: 20/04/2023
-- Description: Elimina un registro de Dueño de mascota y sus registros de mascotas asociadas
-- =============================================
CREATE PROCEDURE [dbo].[usp_DUE_DeleteDueno]
	@intDuenoId			INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		SAVE TRANSACTION DeleteDueno;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;

	BEGIN TRY

		BEGIN

	DELETE FROM [dbo].[Dueno]
		WHERE duenoId = @intDuenoId 

		
	DELETE FROM [dbo].[Mascota]
		WHERE duenoId = @intDuenoId 
									
		END

		-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos determinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1 
				ROLLBACK TRANSACTION DeleteDueno;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH	

END
GO


--****************************************************************************************************************************************************

/****** Object:  Table [dbo].[Dueno]    Script Date: 20/4/2023 17:35:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dueno]') AND type in (N'U'))
DROP TABLE [dbo].[Dueno]
GO

/****** Object:  Table [dbo].[Dueno]    Script Date: 20/4/2023 17:35:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dueno](
	[duenoId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[apellidos] [varchar](250) NOT NULL,
	[direccion] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Dueno] PRIMARY KEY CLUSTERED 
(
	[duenoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--****************************************************************************************************************************************************

/****** Object:  Table [dbo].[Mascota]    Script Date: 21/4/2023 10:35:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mascota]') AND type in (N'U'))
DROP TABLE [dbo].[Mascota]
GO

/****** Object:  Table [dbo].[Mascota]    Script Date: 21/4/2023 10:35:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Mascota](
	[mascotaId] [int] IDENTITY(1,1) NOT NULL,
	[duenoId] [int] NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[tipoMascotaId] [int] NOT NULL,
	[razaMascotaId] [int] NULL,
	[edad] [date] NOT NULL,
 CONSTRAINT [PK_Mascota] PRIMARY KEY CLUSTERED 
(
	[mascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--****************************************************************************************************************************************************

/****** Object:  Table [dbo].[RazaMascota]    Script Date: 21/4/2023 10:37:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RazaMascota]') AND type in (N'U'))
DROP TABLE [dbo].[RazaMascota]
GO

/****** Object:  Table [dbo].[RazaMascota]    Script Date: 21/4/2023 10:37:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RazaMascota](
	[razaMascotaId] [int] IDENTITY(1,1) NOT NULL,
	[tipoMascotaId] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_RazaMascota] PRIMARY KEY CLUSTERED 
(
	[razaMascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--****************************************************************************************************************************************************
/****** Object:  Table [dbo].[TipoMascota]    Script Date: 21/4/2023 10:37:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TipoMascota]') AND type in (N'U'))
DROP TABLE [dbo].[TipoMascota]
GO

/****** Object:  Table [dbo].[TipoMascota]    Script Date: 21/4/2023 10:37:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoMascota](
	[tipoMascotaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TipoMascota] PRIMARY KEY CLUSTERED 
(
	[tipoMascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--****************************************************************************************************************************************************


/****** Object:  Table [dbo].[Dueno]    Script Date: 21/4/2023 10:46:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dueno]') AND type in (N'U'))
DROP TABLE [dbo].[Dueno]
GO

/****** Object:  Table [dbo].[Dueno]    Script Date: 21/4/2023 10:46:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dueno](
	[duenoId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[apellidos] [varchar](250) NOT NULL,
	[direccion] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Dueno] PRIMARY KEY CLUSTERED 
(
	[duenoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--****************************************************************************************************************************************************


/****** Object:  Table [dbo].[Mascota]    Script Date: 21/4/2023 10:46:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mascota]') AND type in (N'U'))
DROP TABLE [dbo].[Mascota]
GO

/****** Object:  Table [dbo].[Mascota]    Script Date: 21/4/2023 10:46:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Mascota](
	[mascotaId] [int] IDENTITY(1,1) NOT NULL,
	[duenoId] [int] NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[tipoMascotaId] [int] NOT NULL,
	[razaMascotaId] [int] NULL,
	[edad] [date] NOT NULL,
 CONSTRAINT [PK_Mascota] PRIMARY KEY CLUSTERED 
(
	[mascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--****************************************************************************************************************************************************



/****** Object:  Table [dbo].[RazaMascota]    Script Date: 21/4/2023 10:46:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RazaMascota]') AND type in (N'U'))
DROP TABLE [dbo].[RazaMascota]
GO

/****** Object:  Table [dbo].[RazaMascota]    Script Date: 21/4/2023 10:46:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RazaMascota](
	[razaMascotaId] [int] IDENTITY(1,1) NOT NULL,
	[tipoMascotaId] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_RazaMascota] PRIMARY KEY CLUSTERED 
(
	[razaMascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--****************************************************************************************************************************************************



/****** Object:  Table [dbo].[TipoMascota]    Script Date: 21/4/2023 10:47:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TipoMascota]') AND type in (N'U'))
DROP TABLE [dbo].[TipoMascota]
GO

/****** Object:  Table [dbo].[TipoMascota]    Script Date: 21/4/2023 10:47:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoMascota](
	[tipoMascotaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TipoMascota] PRIMARY KEY CLUSTERED 
(
	[tipoMascotaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_MAS_GetMascotasByDueno]    Script Date: 21/4/2023 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MAS_GetMascotasByDueno]
	@intDuenoId AS INT
AS
BEGIN
		

	SELECT DISTINCT [mas].[mascotaId] AS mascotaId
		  ,[mas].[duenoId]
		  ,[mas].[nombre]
		  ,[mas].[tipoMascotaId]
		  ,[mas].[razaMascotaId]
		  ,[mas].[edad]		  
		  ,YEAR(GETDATE())- YEAR([mas].[edad]) AS edadAnos
		  ,[tip].[nombre] AS [tipoMascota] 
		  ,[raz].[nombre] AS [razaMascota]
	  FROM [dbo].[Mascota] [mas]
	  LEFT OUTER JOIN [dbo].[TipoMascota] [tip] ON ([mas].[tipoMascotaId] = [tip].[tipoMascotaId])
	  LEFT OUTER JOIN [dbo].[RazaMascota] [raz] ON ([tip].[tipoMascotaId] = [raz].[tipoMascotaId] AND [mas].razaMascotaId = [raz].razaMascotaId)
	  WHERE [mas].[duenoId] = @intDuenoId
	ORDER BY [mas].[nombre] DESC

END
GO
--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_MAS_GetMascotasSearch]    Script Date: 21/4/2023 12:26:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_MAS_GetMascotasSearch]
	@varSearchParams AS VARCHAR(250)
AS
BEGIN

	IF(@varSearchParams IS NULL)
		SELECT @varSearchParams = ''
		

	SELECT DISTINCT [mas].[mascotaId] AS mascotaId
		  ,[mas].[duenoId]
		  ,[mas].[nombre]
		  ,[mas].[tipoMascotaId]
		  ,[mas].[razaMascotaId]
		  ,[mas].[edad]		  
		  ,YEAR(GETDATE())- YEAR([mas].[edad]) AS edadAnos
		  ,[tip].[nombre] AS [tipoMascota] 
		  ,[raz].[nombre] AS [razaMascota]
	  FROM [dbo].[Mascota] [mas]
	  LEFT OUTER JOIN [dbo].[TipoMascota] [tip] ON ([mas].[tipoMascotaId] = [tip].[tipoMascotaId])
	  LEFT OUTER JOIN [dbo].[RazaMascota] [raz] ON ([tip].[tipoMascotaId] = [raz].[tipoMascotaId] AND [mas].razaMascotaId = [raz].razaMascotaId)
	  LEFT OUTER JOIN [dbo].[Dueno] [due] ON ([due].[duenoId] = [mas].[duenoId])		  
	  WHERE
	  CASE @varSearchParams 
			WHEN '' THEN 1
			ELSE
				CASE WHEN
					[due].[nombre] LIKE '%'+@varSearchParams+'%' OR
					[due].[apellidos] LIKE '%'+@varSearchParams+'%' OR
					[mas].[nombre] LIKE '%'+@varSearchParams+'%' OR
					[tip].[nombre] LIKE '%'+@varSearchParams+'%' OR
					[raz].[nombre] LIKE '%'+@varSearchParams+'%'
				THEN 1 ELSE 0 END
		END  = 1
	ORDER BY [mas].[nombre] DESC

END
GO


--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_TIP_GetTiposMascotas]    Script Date: 22/4/2023 11:40:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_TIP_GetTiposMascotas]
AS
BEGIN
		

	SELECT DISTINCT [tip].[tipoMascotaId],
			[tip].[nombre]
	  FROM [dbo].[TipoMascota] [tip]
	ORDER BY [tip].[tipoMascotaId] ASC

END
GO


--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_RAZ_GetRazasMascotaByTipo]    Script Date: 22/4/2023 11:43:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_RAZ_GetRazasMascotaByTipo]
	@intTipoMascotaId INT
AS
BEGIN
		

	SELECT DISTINCT [raz].[razaMascotaId],
		[raz].[tipoMascotaId],
		[raz].[nombre]
	  FROM [dbo].[RazaMascota] [raz]
	  WHERE [raz].[tipoMascotaId] = @intTipoMascotaId
	ORDER BY [raz].[nombre] ASC

END
GO




--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_MAS_InsertMascota]    Script Date: 24/4/2023 07:35:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author: Emilio Viscarra Lujan
-- Create date: 20/04/2023
-- Description: Inserta un registro de mascota
-- =============================================
CREATE PROCEDURE [dbo].[usp_MAS_InsertMascota]
	@intDuenoId				INT,	
	@varNombre				VARCHAR(250),
	@intTipoMascotaId		INT,	
	@intRazaMascotaId		INT,	
	@datEdad				DATE,
	@intMascotaId			INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Detectamos si el SP fue llamado desde una transacción activa y 
	-- la guardamos para usarla más tarde.  En el SP, @TranCounter = 0
	-- significa que no existen transacciones activas y que este SP
	-- comenzó una.  @TranCounter > 0 significa que se inició una transacción
	-- antes de la que empezaremos en este SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- Se llamó a este SP cuando ya existe una transacción activa.
		-- Creamos un punto de restauración para poder hacer sólo rollback
		-- de esta transacción si hay algún error.
		SAVE TRANSACTION InsertMascota;
	ELSE
		-- Este SP comienza su propia transacción y no hay otra antes
		BEGIN TRANSACTION;

	BEGIN TRY

		BEGIN

		INSERT INTO [dbo].[Mascota]
				   ([duenoId]
				   ,[nombre]
				   ,[tipoMascotaId]
				   ,[razaMascotaId]
				   ,[edad])
			 VALUES
				   (@intDuenoId
				   ,@varNombre
				   ,@intTipoMascotaId
				   ,@intRazaMascotaId
				   ,@datEdad)
												
			SET @intMascotaId = SCOPE_IDENTITY()
									
		END

		-- Llegamos aquí si no hay errores;  debemos hacer un commit de la transacción
		-- que comenzamos, pero no debemos hacer un comit si hubo una transacción
		-- comenzada anteriormente.
		IF @TranCounter = 0
			-- @TranCounter = 0 significa que no se comenzó ninguna transacción antes de 
			-- esta transacción y por lo tando debemos hacer un comit de nuestra 
			-- stranacción.
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- Hubo un error. Debemos determinar que tipo de rollback debemos hacer.

		IF @TranCounter = 0
			-- Tenemos sólo la transacción que comenzamos en este SP.  Rollback
			-- toda la transacción.
			ROLLBACK TRANSACTION;
		ELSE
			-- Se comenzó una transacción antes de que llamen a este SP. Debemos hacer
			-- un rollback solo de las modificaciones que hicimos en este SP

			-- Vemos XACT_STATE y los posibles resultados son 0, 1, or -1.
			-- Si es 1, la transacción es válida y se puede hacer un comit. Pero como 
			-- estamos en el CATCH no hacemos comit.
			-- Si es -1 la transacción no es válida y se debe hacer un rollback
			-- Si es - Significa que no hay un transacción y que un rollback causaría un error
			-- Ver http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() <> -1
				-- Si la transacción es todavía válida, hacemos un rollback hasta el punto
				-- de restauración definido anteriormente.  
				-- Sólo podemos hacer un rollback si XACT_STATE() = -1 
				ROLLBACK TRANSACTION InsertMascota;

				-- Si la transaccion no es válida no se puede hacer un commit ni un rollback, 
				-- por lo que un rollback al punto de restauración no es permitido por que 
				-- el rollback al punto de restauración escribiría en el log de la base de 
				-- datos.  Símplemente debemos retornar al que nos llamó y este será 
				-- responsable de hacer rollback a la transacción. 

		-- Luego de hacer el rollback correspondiente, debemos propagar la información de error
		-- al SP que nos llamó. 
		--
		-- Ver http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH	

END
GO



--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_TIP_GetTiposMascotaById]    Script Date: 24/4/2023 08:22:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[usp_TIP_GetTiposMascotaById]
	@intTipoMascotaId INT
AS
BEGIN
		

	SELECT DISTINCT [tip].[tipoMascotaId],
			[tip].[nombre]
	  FROM [dbo].[TipoMascota] [tip]
	WHERE [tip].[tipoMascotaId] = @intTipoMascotaId

END
GO


--****************************************************************************************************************************************************
/****** Object:  StoredProcedure [dbo].[usp_RAZ_GetRazaMascotaById]    Script Date: 24/4/2023 08:30:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_RAZ_GetRazaMascotaById]
	@intRazaMascotaId INT
AS
BEGIN
		

	SELECT DISTINCT [raz].[razaMascotaId],
		[raz].[tipoMascotaId],
		[raz].[nombre]
	  FROM [dbo].[RazaMascota] [raz]
	WHERE [raz].[razaMascotaId] = @intRazaMascotaId

END
GO




--****************************************************************************************************************************************************

/****** Object:  StoredProcedure [dbo].[usp_MAS_GetMascotaById]    Script Date: 24/4/2023 12:44:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_MAS_GetMascotaById]
	@intMascotaId AS INT
AS
BEGIN
		

	SELECT DISTINCT [mas].[mascotaId] AS mascotaId
		  ,[mas].[duenoId]
		  ,[mas].[nombre]
		  ,[mas].[tipoMascotaId]
		  ,[mas].[razaMascotaId]
		  ,[mas].[edad]
		  ,YEAR(GETDATE())- YEAR([mas].[edad]) AS edadAnos
		  ,[tip].[nombre] AS [tipoMascota] 
		  ,[raz].[nombre] AS [razaMascota]
	  FROM [dbo].[Mascota] [mas]
	  LEFT OUTER JOIN [dbo].[TipoMascota] [tip] ON ([mas].[tipoMascotaId] = [tip].[tipoMascotaId])
	  LEFT OUTER JOIN [dbo].[RazaMascota] [raz] ON ([tip].[tipoMascotaId] = [raz].[tipoMascotaId] AND [mas].razaMascotaId = [raz].razaMascotaId)
	  WHERE [mas].[mascotaId] = @intMascotaId

END
GO



--****************************************************************************************************************************************************

/* INITIALIZE TIPOS Y RAZAS DE MASCOTA */

DELETE FROM [dbo].[Dueno]
DELETE FROM [dbo].[Mascota]
DELETE FROM [dbo].[TipoMascota]
DELETE FROM [dbo].[RazaMascota]



SET IDENTITY_INSERT [dbo].[TipoMascota] ON
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (1,'Gato')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (2,'Perro')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (3,'Tortuga')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (4,'Loro')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (5,'Peces')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (6,'Lagartija')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (7,'Mono')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (8,'Cerdo')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (9,'Ajolote')
INSERT INTO [dbo].[TipoMascota] ([tipoMascotaId],[nombre]) VALUES (10,'Hamster')
SET IDENTITY_INSERT [dbo].[TipoMascota] OFF



INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Mestizo')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Persa')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Azul Ruso')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Siamés')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Angora Turco')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Siberiano')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Main Coon')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (1 ,'Bengalí')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Mestizo')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Golden retriever')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Bulldog francés')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Pastor alemán')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Caniche')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Chihuahua')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Beagle')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Rottweiler')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Boxer')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (2 ,'Husky siberiano')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (3 ,'Marina')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (3 ,'Pintada')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (3 ,'Del bosque')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (3 ,'Rusa')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (4 ,'Amazonas')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (4 ,'Periquitos')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (4 ,'Papagayos')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (5 ,'Dorados')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (6 ,'Gecos leopardo')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (6 ,'Iguania')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (7 ,'Macaco')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (7 ,'Dril')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (7 ,'Catarrino')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (7 ,'Capuccino')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (7 ,'Tití rojizo')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (8 ,'Duroc')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (8 ,'Hampshire')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (8 ,'Kunekune')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (8 ,'Chester white')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (9 ,'Blanco')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (9 ,'Albino')

INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (10 ,'Ruso')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (10 ,'Enano')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (10 ,'Roborowski')
INSERT INTO [dbo].[RazaMascota] ([tipoMascotaId],[nombre]) VALUES (10 ,'Sirio')




--****************************************************************************************************************************************************


--****************************************************************************************************************************************************


--****************************************************************************************************************************************************





