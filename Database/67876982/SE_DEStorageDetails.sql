
USE [ExactTarget51075];
GO


SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON; 
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO

IF OBJECT_ID('[C536001940].[_SE_DEStorageDetails]') IS NULL
   BEGIN
   	EXEC sp_executesql N'CREATE VIEW [C536001940].[_SE_DEStorageDetails] AS SELECT 1 AS temp';
   END;
GO


ALTER VIEW [C536001940].[_SE_DEStorageDetails]
AS 
SELECT
    ts.SampleTime,
    co.MemberID AS 'MID',
    co.CustomObjectName AS 'DataExtensionName',
    co.CustomerKey AS 'ExternalKey',
    co.IsSendable AS 'IsSendable',
    CASE
        WHEN DataRetentionPeriodLength IS NULL THEN 0
        ELSE 1
    END AS 'HasDataRetentionPolicy',
    ts.[RowCount] AS 'RecordCount',
    ts.DataMB AS 'UsedMB'
FROM
    worktabledb.dbo.tablesize ts
WITH
    (NOLOCK)
    LEFT JOIN dbo.CustomObject co WITH
    (NOLOCK) ON (
        co.CustomObjectName = ts.TableName
        /* tsqllint-disable error non-SARGable */
        AND SUBSTRING(ts.SchemaName, 2, LEN (ts.SchemaName) -1) = co.MemberID
        /* tsqllint-enable error non-SARGable */

    ) 
WHERE
    co.IsActive = 1
    AND ts.schemaname IN(
    'C536001940',
    'C536005893',
    'C536005511',
    'C536005515',
    'C536005513',
    'C536005521',
    'C536005512',
    'C536005514',
    'C536003936',
    'C536004376',
    'C536002075',
    'C536002074',
    'C536005418',
    'C536004420')
	/* tsqllint-disable error non-SARGable */
    AND ts.SampleTime >= DATEADD (MONTH, -3, GETDATE ())
	/* tsqllint-enable error non-SARGable */
	UNION ALL
		SELECT '','','','','','','','' WHERE 1=0;
GO

/* end Code */
