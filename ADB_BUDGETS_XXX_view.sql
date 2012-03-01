
  CREATE OR REPLACE FORCE VIEW "APPS"."ADB_BUDGETS_XXX" ("BUDGET_NAME", "BUDGET_TYPE", "DESCRIPTION", "STATUS", "DATE_CREATED", "FIRST_PERIOD_NAME", "LAST_PERIOD_NAME", "BUDGET_VERSION_ID") AS 
  select bud.budget_name                                   Budget_Name
      ,bud.budget_type                                   Budget_Type
      ,bud.description                                   Description
      ,decode(bud.status,'O','Open','C','Current',
                         'F','Frozen','I','Inactive',
                         'R','Running Copy',null)        Status
      ,bud.date_created                                  Date_Created
      ,bud.first_valid_period_name                       First_Period_Name
      ,bud.last_valid_period_name                        Last_Period_Name
      ,ver.budget_version_id                             Budget_Version_Id
from   gl_budget_versions      ver
      ,gl_budgets              bud
where  bud.budget_name             =  ver.budget_name
and    bud.budget_type             =  ver.budget_type

 