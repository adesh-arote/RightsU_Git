select * from system_module where Module_Name like '%Title%'

select * from System_Module_Right where Module_Code = 27

select * from System_Right where Right_Code in (
1
,2
,3
,4
,7
,9
,128
,137
,121
,10
,160
)

update System_Parameter set Parameter_Value = 'N' where Parameter_Name = 'Is_Allow_Perpetual_Date_Logic'