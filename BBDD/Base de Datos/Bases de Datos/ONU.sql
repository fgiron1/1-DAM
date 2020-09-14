CREATE DATABASE ONU
GO

USE ONU
GO

CREATE Table OInfraestructuras (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OCatastrofes (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OPlanes (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OEnvios (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OPaises (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OOrganizaciones (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OTransportes (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OProductos (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OSuministros (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OEquipamientos (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OTiposCatastrofe (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OOrganizacionesSuministros (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OOrganizacionesPaises (

	ID_Organizaciones SmallInt Not NULL Identity (1,1),
	ID_Paises SmallInt Not NULL,

	Constraint PKOrganizacionesPaises Primary Key (ID_Organizaciones, ID_Paises),
	Constraint FKOrganizaciones Foreign Key (ID_Organizaciones) REFERENCES OOrganizaciones (ID),
	Constraint FKPaises Foreign Key (ID_Paises) REFERENCES OPaises (ID) ON DELETE NO ACTION ON UPDATE Cascade
)
GO

CREATE Table OPaisesCatastrofes (

	ID SmallInt Not NULL Identity (1,1),

	Constraint PKInfraestructuras Primary Key (ID)
)
GO

CREATE Table OEnviosProductos (

	ID_Envio SmallInt Not NULL Identity (1,1),
	ID_Producto SmallInt Not NULL,

	Constraint PKEnviosProductos Primary Key (ID_Envio, ID_Producto),
	Constraint FKEnviosaProductos Foreign Key (ID_Envio) REFERENCES OEnvios (ID),
	Constraint FKProductosaEnvios Foreign Key (ID_Producto) REFERENCES OProductos (ID)
)
GO