Directories and the material they contain:

DWH ERD:              Entity Relation Disgram of the Product Reviews Dimensional Model.
Product_Reviews_DWH:  DBT Project Directory, contains all the models.
Database Objects:     Contains the DDL of all the tables involved in dimensional model and other additional function. 
Ingest Sources:       Contains the python script to load the download datasets and load in raw format.
logs:			            Contains dbt logs. (ignore it. not important)
Talend Pipeline:      Contains the Talend job, can be scheduled multiple times in a day for incremental runs.
Presentation Layer:   Contains the view, fact table joined with all the dimension, to have the one consolidated dataset for BI
