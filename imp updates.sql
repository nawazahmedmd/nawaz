In Microsoft Windows, click the Start button, and then click Control Panel.
Open the dialog box for changing Regional and Language settings.
In the dialog box, look for the List separator setting. (Location may vary based on Windows version. You may need to open Additional settings... on the Format tab to find it.)
Enter the desired list separator.
Click Apply and then click OK. (Or Click OK, then click Apply and then click OK.)


update legacy.tmed_data td 
set updated_on = '2022-03-29 16:50:08.000', added_on ='2021-12-14 10:30:12.110',  status = '1'
where status = '14-DEC-21 10.30.12.110685 AM';

update legacy.tmed_rbac_organizations 
set created_on = '1970-01-01'
where created_on ='2070-01-01';

INSERT INTO legacy.wrk_xref_codes
(src_sys_id, legacy_tbl_nm, legacy_col_nm, from_xref_cd, from_xref_desc, ref_tbl_nm, to_xref_cd, to_xref_desc, create_dt, update_dt)
VALUES('MMIS', 'T_CDE_DISENROLL_REASONS', 'DESC_DISENROLL_RSN', '14', 'Member Deceased', 'DISENROLLMENT_REASON', 'MDE', 'Member Deceased', '2020-09-24 12:00:00.000', NULL);


INSERT INTO legacy.wrk_xref_codes
(src_sys_id, legacy_tbl_nm, legacy_col_nm, from_xref_cd, from_xref_desc, ref_tbl_nm, to_xref_cd, to_xref_desc, create_dt, update_dt)
VALUES('MMIS', 'T_CDE_DISENROLL_REASONS', 'DESC_DISENROLL_RSN', '15', 'Penalty Period', 'DISENROLLMENT_REASON', 'PEN', 'Penalty Period', '2020-09-24 12:00:00.000', NULL);

INSERT INTO legacy.wrk_xref_codes
(src_sys_id, legacy_tbl_nm, legacy_col_nm, from_xref_cd, from_xref_desc, ref_tbl_nm, to_xref_cd, to_xref_desc, create_dt, update_dt)
VALUES('TPAES', 'ECF_STAGING', 'ZIP-COUNTY', '34851', NULL, 'COUNTY', '058', 'TIPTON', '2021-08-18 00:00:00.000', NULL);


update legacy.pasrr_doc
set upload_date = '2019-02-04 08:24:02.840000000',
filesize = '1 MB' , attatchmentid = '331412',mimetype='application/pdf',attachmenttype='History and Physical'
where reviewid = '216594' and attatchmentid = '2019'

update legacy.pasrr_doc
set attachmenttype='History and Physical'
where reviewid = '216594' and attatchmentid = '331412';

update legacy.pasrr_doc
set filename='df94d424-285d-47d2-be53-deb6debb7843-F:\PAE|Sweeneym-PAE.'
where reviewid = '216594' and attatchmentid = '331412';

select * from legacy.pasrr_doc 
where upload_date like '%1 MB%'


 update legacy.pasrr_doc
 set upload_date_new = upload_date::timestamp
 
 update legacy.pasrr_blob
 set upload_date = uploaddate::timestamp;

update legacy.pasrr_blob
 set actual_file_name = trim(episodeguid||'-'||filename);
 
  update legacy.pasrr_blob_final
 set upload_date = uploaddate::timestamp;

update legacy.pasrr_blob_final
 set actual_file_name = trim(episodeguid||'-'||filename);


update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='04-Aug-1931' where num_control_pkey=1216645;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='05-Dec-1963' where num_control_pkey=1216653;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='17-Mar-1937' where num_control_pkey=1214438;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='31-Aug-1953' where num_control_pkey=1383919;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='30-Apr-1962' where num_control_pkey=1498054;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='01-Jul-1931' where num_control_pkey=1583280;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='19-Feb-1959' where num_control_pkey=1681756;
update  legacy.tmed_PASRR_ASCEND_EXTRACT set TR_TRANSFERDATE='14-May-1941' where num_control_pkey=1604434;

alter table legacy.tmed_data add data_new xml;

update legacy.tmed_data 
set data_new = data::xml
where num_control_pkey not in
('1279118','1287065','1318763','1421343','1647550');

UPDATE legacy.pasrr_mmis_t_pub_hlth_pgm pmtphp 
set ind_recip_only='N',	ind_major_pgm='N',	ind_stand_alone='N',	ind_dual='Y',	ind_ct_editing='I',	ind_copay='N',	ind_setup='N',	cde_enrollment=' ',	elig_window_filter='N'
where sak_pub_hlth = '1012';

UPDATE legacy.pasrr_mmis_t_pub_hlth_pgm pmtphp 
set ind_recip_only='N',	ind_major_pgm='N',	ind_stand_alone='N',	ind_dual='Y',	ind_ct_editing='I',	ind_copay='N',	ind_setup='N',	cde_enrollment=' ',	elig_window_filter='N'
where sak_pub_hlth = '1030';

delete  from legacy.pasrr_mmis_t_pub_hlth_pgm where sak_pub_hlth =0;

update legacy.tmed_data
set updated_on = '2022-03-29 16:50:08.000', added_on = '2021-12-14 10:30:12.110', status = '1'
where num_control_pkey = 1647550;

alter table legacy.tmed_data add data_new xml;

select * from legacy.ecf_recipients_20241017  where ssn like '0%'; --6042
select * from legacy.ch3a_recipients_20241017  where ssn like '0%'; --3624
select * from legacy.kb_recipients_20241017 where ssn like '0%'; --4218

select * from legacy.ecf_recipients_20241017  where ssn ='759102609'; --6042
select * from legacy.ch3a_recipients_20241017  where ssn ='408555074'; --3624
select * from legacy.kb_recipients_20241017 where ssn ='291692243'; --4218

select * from legacy.ecf_recipients_20241017; --6042
select * from legacy.ch3a_recipients_20241017; --3624
select * from legacy.kb_recipients_20241017; --4218


grant all on legacy.ecf_recipients_20241017 to public; --5974
grant all on legacy.ch3a_recipients_20241017 to public; --3509
grant all on legacy.kb_recipients_20241017 to public; --3898



select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_pat_liab b on a.sak_recip =b.sak_recip;

select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_mc_re_sum_elig  b on a.sak_recip =b.sak_recip;

select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_pmp_assign  b on a.sak_recip =b.sak_recip;

select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_elig  b on a.sak_recip =b.sak_recip;

select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_choices_tracking  b on a.sak_recip =b.sak_recip;


select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_loc  b on a.sak_recip =b.sak_recip;

select COUNT(1) from LEGACY.pasrr_mmis_t_re_base a
join legacy.pasrr_mmis_t_re_disenroll_reasons  b on a.sak_recip =b.sak_recip;


select count(1), pae_id from perlss.pae_lvng_arrgmnt
where created_by = 'PASRR_CV'
group by pae_id
having count(1)>1;

delete from perlss.pae_lvng_arrgmnt where pae_id in ('PAE200108831','PAE200109737')
and nursing_facility_name_cd = '147';

select * from perlss.com_provider_master where provider_id in ('Q052122','Q052849');



insert into perlss.enr_bnft  (id, enr_id, enr_bnft_type_cd, enr_bnft_grp_cd, enr_bnft_amt, enr_bnft_eff_dt, enr_bnft_end_Dt , created_dt, last_modified_by, last_modified_dt, record_version, archived_dt, created_by, lon_cd  )
(
select (select max(id) from perlss.enr_bnft eb) + row_number() over (order by a.enr_id) as id, 
a.* 
from
(
select 
distinct
    er.enr_id ,
	prd.code as enr_bnft_type_cd,
	'ADON' as enr_bnft_grp_cd,
	to_number(prd.value,'9999999') as enr_bnft_amt,
	er.enr_start_dt as enr_bnft_eff_dt,
	er.enr_end_Dt as enr_bnft_end_Dt,
	er.created_dt ,
	er.last_modified_by,
	er.last_modified_dt ,
	er.record_version ,
	er.archived_dt ,
	'CV_I34' as created_by,
	null as lon_cd
from
	perlss.adj_rqst ar
join perlss.enr_rqst er on	ar.pae_id = er.pae_id
join perlss.com_applcnt ca on	ca.prsn_id = er.prsn_id
inner join perlss.adj_skilled_srvcs ass on	ass.adj_id = ar.adj_id
inner join legacy.perlss_reference_data prd on	prd.code = ass.srvc_name_cd
inner join legacy.pasrr_mmis_base_member_pop wmbmp on	wmbmp.num_ssn = ca.ssn
where er.created_by='PASRR_CV' 
	er.enr_grp_cd = 'CG1'
	and ass.srvc_name_cd in ('SMT', 'CVS')
	and prd.name = 'ENROLLMENT_ADDON_AMOUNT'
	and ltrim(rtrim(wmbmp.cde_pgm_health)) = 'CH1B'
) a
);


75067319

AA00E551RP

AA00E5640N-saf

717 800 533 8762

7175030701

717703 1111 ct

select woundcaredecubitus,woundcareother,selfinjection,
selfinjection,	parenteralnutrition	,tubefeeding,	peritonealdialysis,	pcapump,	tracheostomy
injectionsinsulin,	injectionsother,	intravenousfluids,	isolationprecautions,
occupationaltherapy,	physicaltherapy,	catheterostomy
from legacy.pasrr_loc pl 
where eventid in (select eventid from legacy.pasrr_events where reviewid = '611699');


select * from perlss.cnv_doc_dtls 
where created_by ='PASRR_CV' and prsn_id = '6000029657' and file_name like 'idd%'

select * from perlss.doc_module_mapping dmm 
where created_by ilike '%DOC%' and prsn_id = '6000029657'
order by created_dt desc ;

select distinct d.ssn,d.individualid, e.reviewid, e.payersource, l.level1outcome,level1determinationdate
,level1submissiondate, level1determinationeffectivedate,level1determinationenddate
from perlss.adj_pasrr_outcome a 
join perlss.adj_rqst b on a.adj_id = b.adj_id 
join perlss.com_applcnt ca on ca.prsn_id = b.prsn_id and ca.active_sw ='Y' and ca.file_clearance_sw='Y'
join legacy.pasrr_demographics d on d.ssn = ca.ssn
join legacy.pasrr_events e on e.individualid = d.individualid
left join legacy.pasrr_level_i l on l.eventid = e.eventid
where a.created_by <> 'PASRR_CV' 
and a.lvl1_dcsn_cd = 'NEG' 
and a.payor_src_cd in ('MD','AP');


select * from legacy.pasrr_pae_base_member_pop a
join legacy.wrk_pasrr_clients b on a.pasrr_review_id::text = b.maximus_reviewid::text
where perlss_sw= 'N' and valid_sw ='Y' and xref_valid_sw ='Y';


with sq as (
select pr.id,currentlocationfacility,referralfacility,legacy_id,xss.perlss_entity_id as entity_id, sot.entity_type
from perlss.pae_rqst pr
inner join (select currentlocationfacility,referralfacility,reviewid from legacy.pasrr_events pe  
           inner join legacy.pasrr_loc  pli on pe.eventid=pli.eventid)x 
           on x.reviewid::text=trim(pr.legacy_id)
inner join legacy.xref_subfacility_secorg xss on xss.level1submittingfacility=referralfacility
--inner join legacy.xref_subfacility_secorg xsd on xsd.level1submittingfacility=currentlocationfacility
left join perlss.sec_organization so on so.entity_id::text = xss.perlss_entity_id::text
left join perlss.sec_org_type sot on so.entity_type_id = sot.entity_type_id
 where pr.created_by ='PASRR_CV' and pr.entity_id is null and xss.perlss_entity_id is not null)
update perlss.pae_rqst p
set entity_id = sq.entity_id::int , entity_type=sq.entity_type
from sq where sq.id = p.id and p.created_by = 'PASRR_CV';



with sq as (
select pr.id,currentlocationfacility,referralfacility,
legacy_id,xsd.perlss_entity_id as entity_id, sot.entity_type, so.entity_name
from perlss.pae_rqst pr
inner join (select currentlocationfacility,referralfacility,reviewid from legacy.pasrr_events pe  
           inner join legacy.pasrr_loc  pli on pe.eventid=pli.eventid)x 
           on x.reviewid::text=trim(pr.legacy_id)
--inner join legacy.xref_subfacility_secorg xss on xss.level1submittingfacility=referralfacility
inner join legacy.xref_subfacility_secorg xsd on xsd.level1submittingfacility=currentlocationfacility
left join perlss.sec_organization so on so.entity_id::text = xsd.perlss_entity_id::text
left join perlss.sec_org_type sot on so.entity_type_id = sot.entity_type_id
 where pr.created_by ='PASRR_CV' and pr.entity_id is null and xsd.perlss_entity_id is not null)
update perlss.pae_rqst p
set entity_id = sq.entity_id::int , entity_type=sq.entity_type
from sq where sq.id = p.id and p.created_by = 'PASRR_CV';


 
--not needed now
update perlss.adj_rqst c
set entity_id = d.entity_id from  
					(select distinct pae_id ,entity_id 
					from perlss.pae_rqst where  created_by = 'PASRR_CV' and entity_id is not null) d 
where  created_by = 'PASRR_CV' and d.pae_id = c.pae_id and c.entity_id is null






--done
update perlss.pae_lvng_arrgmnt 
set lvng_arrgmnt_desc = 'Conversion'
where created_by = 'PASRR_CV'  and curr_lvng_arrgmnt_cd ='OTH';


--not needednow
update perlss.adj_skilled_srvcs 
set tracheal_scrn_req_sw ='N'
where tracheal_scrn_req_sw ='F' and created_by ='PASRR_CV'
;

--done
update perlss.adj_skilled_srvcs
set acuity_score =0 
where created_by = 'PASRR_CV' and adjctor_rsp_cd ='D';
--done
with sq as (
select distinct a.srvc_name_cd , b.acuity_score from perlss.adj_skilled_srvcs a 
join legacy.xref_srvcs_score b on a.srvc_name_cd  = b.srvc_name_cd
where a.created_by = 'PASRR_CV' and a.acuity_score is null and a.adjctor_rsp_cd ='A')
update perlss.adj_skilled_srvcs p
set acuity_score = sq.acuity_score
from sq where sq.srvc_name_cd = p.srvc_name_cd
and p.created_by = 'PASRR_CV' and p.acuity_score is null and p.adjctor_rsp_cd ='A';









select * from legacy.tmed_data;
select * from legacy.tmed_audit_trail_types;
select * from legacy.tmed_all_submissions;
select * from legacy.tmed_attachment;
select * from legacy.tmed_audit_trail;
select * from legacy.tmed_notification_log;
select * from legacy.tmed_i_pasrr_req;
select * from legacy.tmed_notification_criteria;
select * from legacy.tmed_i_pasrr_screening_mapping;
select * from legacy.tmed_notification_template;
select * from legacy.tmed_project_type;
select * from legacy.tmed_notification_method;
select * from legacy.tmed_notifications;
select * from legacy.tmed_pasrr_ascend_extract;
select * from legacy.tmed_notification_rcvr_types;
select * from legacy.tmed_notification_receivers;
select * from legacy.tmed_rbac_domains;
select * from legacy.tmed_notification_types;
select * from legacy.tmed_i_pasrr_attach;
select * from legacy.tmed_i_pasrr_disp;
select * from legacy.tmed_rbac_domains_map;
select * from legacy.tmed_rbac_roles;
select * from legacy.tmed_rbac_groups;
select * from legacy.tmed_rbac_groups_map;
select * from legacy.tmed_rbac_organizations;
select * from legacy.tmed_rbac_users;
select * from legacy.tmed_rbac_organizations_map;
select * from legacy.tmed_rbac_users_map;
select * from legacy.tmed_rbac_permissions;
select * from legacy.tmed_rbac_roles_map;
select * from legacy.tmed_rbac_status_codes;
select * from legacy.tmed_recepient_details;
select * from legacy.tmed_request_type;
select * from legacy.tmed_service_request_type;
select * from legacy.tmed_template_names;
select * from legacy.tmed_workflow_path;
select * from legacy.tmed_workflow_task_assignment;
select * from legacy.tmed_template_xslt;
select * from legacy.tmed_workflow_details;
--done
update perlss.com_notes c
set episode_id = d.legacy_id from  
					(select distinct pae_id ,legacy_id 
					from perlss.pae_rqst where  created_by = 'PASRR_CV') d 
where d.pae_id = c.pae_id and  c.created_by = 'PASRR_CV';
--done
update perlss.com_comments c
set episode_id = d.legacy_id from  
					(select distinct pae_id ,legacy_id 
					from perlss.pae_rqst where  created_by = 'PASRR_CV') d 
where d.pae_id = c.pae_id and  c.created_by = 'PASRR_CV';

with sq
(select a.review_id , a.ascend_id , a.upload_dt , b.attachment_type from perlss.int_pasrr_doc_sync_stg a
join legacy.int_pasrr_doc_sync_stg b
on a.review_id =b.review_id and a.ascend_id =b.ascend_id and a.upload_dt =b.upload_dt);

insert into legacy.pasrr_blob_final
(episodeid,	clientid,	episodeguid,	attachmentid,	attachmenttype,
mimetype,	azuredocumentid,	uploaddate,	upload_date,	filename,	actual_file_name)
select episodeid,	clientid,	episodeguid,	attachmentid,	attachmenttype,
mimetype,	azuredocumentid,	uploaddate,	upload_date,	filename,	actual_file_name from legacy.pasrr_blob

update perlss.cnv_task c
set pasrr_id = d.pasrr_id from  
					(select distinct pae_id ,pasrr_id,prsn_id 
					from perlss.pasrr_rqst where  created_by = 'PASRR_CV' and last_modified_by is null) d 
where d.pae_id = c.pae_id and d.prsn_id =c.prsn_id
and c.pasrr_id is null and c.created_by = 'PASRR_CV';

update perlss.cnv_task c
set created_dt = current_date
where c.created_by = 'PASRR_CV';

update perlss.tmg_task c
set pasrr_id = d.pasrr_id from  
					(select distinct pae_id ,pasrr_id 
					from perlss.pasrr_rqst where  created_by = 'PASRR_CV') d 
where created_dt ::date =current_date and d.pae_id = c.pae_id and c.pasrr_id is null

UPDATE  perlss.enr_rqst
set enr_denial_rsn_cd='DEC'
where prsn_id = '6000068309' and id = '1856089974'

select * from legacy.fe_check 
where coe_id  in ('W01','L02','L01','W02','L03','L04', 'SSI')
and (eligibility_end_dt is null or eligibility_end_dt > current_date)	   
				   
select  distinct b.pae_id,b.adj_id,submittedacuityscore src_submittedacuityscore,c.total_assessed_acty_score, approvedacuityscore src_approvedacuityscore,total_adj_acuity_score
 from --perlss.adj_functnl_assmnt a join 
 perlss.adj_rqst b --on a.adj_id=b.adj_id
join perlss.adj_dtls c on b.adj_id=c.adj_id
join perlss.pae_rqst p on p.pae_id=b.pae_id
join (select  b.reviewid ,submittedacuityscore, approvedacuityscore   from legacy.pasrr_loc a  join legacy.pasrr_events b  on b.eventid =a.eventid )s
on trim(s.reviewid::text)=trim(p.legacy_id )
where b.created_by='PASRR_CV'
--and  total_assessed_acty_score is null --373
--and  total_adj_acuity_score is null--373
--and total_adj_acuity_score =approvedacuityscore
--and submittedacuityscore=total_assessed_acty_score
--and submittedacuityscore<>total_assessed_acty_score
and  total_adj_acuity_score <>approvedacuityscore
--and b.pae_id='PAE200113159'
order by  pae_id


select distinct completed_comments,tmed_num_control_pkey ,pasrr_review_id
from legacy.tmed_xml_extract_cv_qlf_no_rec a
join legacy.pasrr_pae_base_member_pop b on a.num_control::text = b.tmed_num_control_pkey ::text
join perlss.pae_rqst c on c.legacy_id::text = b.pasrr_review_id::text
where completed_comments ilike '%MOPD%'  and c.created_by ='PASRR_CV'
--and c.mopd_dt is null
;




select '''' || pae_id || '''' || ',' from perlss.pae_rqst where created_by ='PASRR_CV' and legacy_id::text in (
select  pasrr_review_id::text from (
select step, ssn,pasrr_review_id,level2determinationdate,
rank() OVER (PARTITION BY ssn  ORDER by  level2determinationdate desc )temp_rnk from 
legacy.pasrr_pae_base_member_pop b where  step in('3','5')
and    ssn in(select  ssn from legacy.pasrr_pae_base_member_pop a where  step='3' 
and exists(select  * from legacy.pasrr_pae_base_member_pop b where  a.ssn=b.ssn and b.step in('5'))))zz
where  temp_rnk=2
order by ssn,temp_rnk);

select distinct a.prsn_id , a.pae_id  ,b.task_dtl_desc , c.assigned_mco_sw,c.entity_type_cd,
a.entity_id as pae_entity_id,b.entity_id tmg_task_entity_id , c.entity_id as com_applcnt_enity_id
from perlss.pae_rqst a
join perlss.tmg_task b on a.pae_id = b.pae_id
left join perlss.com_applcnt_access c on c.prsn_id = a.prsn_id and a.pae_id = c.pae_id 
--left join perlss.sec_organization so on c.entity_id = so.entity_id
where a.created_by = 'PASRR_CV'  
order by 3;

select distinct passr_pi__nursingfacilitynpinumber,tmed_num_control_pkey ,pasrr_review_id, c.pae_id
from legacy.tmed_xml_extract_cv_qlf_no_rec a
join legacy.pasrr_pae_base_member_pop b on a.num_control::text = b.tmed_num_control_pkey ::text
join perlss.pae_rqst c on c.legacy_id::text = b.pasrr_review_id::text
join perlss.cnv_task d on c.pae_id = d.pae_id and c.prsn_id =d.prsn_id
where d.task_master_id =180 --and passr_pi__nursingfacilitynpinumber is not null
;


SELECT
    conrelid::regclass AS child_table,
    confrelid::regclass AS parent_table
--    conname AS constraint_name
FROM pg_constraint
WHERE  conrelid::regclass = 'perlss.tmg_task'::regclass
ORDER BY parent_table, child_table;



with sq as (
select distinct a.pae_id  , e.provider_id , e.o_id, b.legacy_id , e.ascendid, e.admissiondate, a.admsn_dt
				from perlss.pae_lvng_arrgmnt a 
				join perlss.pae_rqst b on a.pae_id = b.pae_id
				join legacy.pasrr_events c on c.reviewid::text = b.legacy_id::text
				join legacy.pasrr_demographics d on d.individualid =c.individualid 
				join legacy.pathtracker_data e on e.ascendid::text = d.ascendid ::text
				where b.created_by = 'PASRR_CV' 
				and e.provider_id is not null )
update perlss.pae_lvng_arrgmnt p
set lvng_arrgmnt_desc = null ,
othr_facility_name = null , 
org_id= sq.o_id,
org_loc_id= sq.o_id,
provider_id= sq.provider_id,
admsn_dt= case when p.admsn_dt is null then sq.admissiondate end ,
nursing_facility_name_cd= sq.o_id, last_modified_by ='PASRR_CV_PT'
from sq where sq.pae_id = p.pae_id and p.created_by = 'PASRR_CV' and p.provider_id is null;



with sq as (
select distinct b.pae_id  , b.mopd_dt , e.admissiondate, c.reviewid , c.nfadmitdate
from perlss.pae_lvng_arrgmnt a 
join perlss.pae_rqst b on a.pae_id = b.pae_id
join legacy.pasrr_events c on c.reviewid::text = b.legacy_id::text
join legacy.pasrr_demographics d on d.individualid =c.individualid 
join legacy.pathtracker_data e on e.ascendid::text = d.ascendid ::text
where b.created_by = 'PASRR_CV' and b.mopd_dt is null) 
update perlss.pae_rqst p
set mopd_dt = sq.admissiondate, last_modified_by ='PASRR_CV_PT'
from sq where sq.pae_id = p.pae_id and p.created_by = 'PASRR_CV' and p.mopd_dt is null;


with sq as (
select distinct b.pae_id  , b.mopd_dt , e.admissiondate, c.reviewid , c.nfadmitdate
from perlss.pae_lvng_arrgmnt a 
join perlss.pae_rqst b on a.pae_id = b.pae_id
join legacy.pasrr_events c on c.reviewid::text = b.legacy_id::text
join legacy.pasrr_demographics d on d.individualid =c.individualid 
join legacy.pathtracker_data e on e.ascendid::text = d.ascendid ::text
where b.created_by = 'PASRR_CV' and a.admsn_dt is null) 
update perlss.pae_lvng_arrgmnt p
set admsn_dt = sq.admissiondate, last_modified_by ='PASRR_CV_PT'
from sq where sq.pae_id = p.pae_id and p.created_by = 'PASRR_CV' and p.admsn_dt is null;


update perlss.adj_dtls set trgt_popltn_phy_diagns_sw ='Y' where created_by ='PASRR_CV' and trgt_popltn_not_meet_sw  ='N';


with tmed as (
select prsn_id,pae_id,count(distinct file_name) tmedcount from perlss.cnv_doc_dtls where created_by ='PASRR_CV'
group by prsn_id,pae_id  ), perlss as (select prsn_id,pae_id ,count( distinct gen_generated_id) perlsscount  from perlss.doc_module_mapping where created_by ='CNV-DOCCV-ADHOC' 
and created_dt ::date = '2025-02-26'-- job execution date
group by prsn_id,pae_id)

select a.prsn_id,b.prsn_id,tmedcount,perlsscount,case
   when tmedcount=perlsscount then 'PASS'
   else 'FAIL'
end as Document_conversion 
from tmed a inner join perlss b on a.prsn_id=b.prsn_id and a.pae_id=b.pae_id;

select * from perlss.enr_rqst where prsn_id =6000067618 and pae_id =	'PAE200112876';

select count(1), task_dtl_desc,task_master_id  from perlss.cnv_task a
join perlss.com_applcnt b on a.prsn_id =b.prsn_id 
left join legacy.pasrr_mmis_t_re_base c on c.num_ssn = b.ssn
where a.created_by='PASRR_CV' and dte_death<>'0'
group by  task_dtl_desc,task_master_id

path tracker
xref sec ORGANIZATION
xref curre facility


 with sq as (
select c.pae_id , c.prsn_id , c.enr_id from perlss.tmg_task a
join perlss.enr_rqst c on a.prsn_id = c.prsn_id and a.pae_id = c.pae_id
where c.created_by ='PASRR_CV' and c.enr_status_cd = 'NEE'
and a.task_dtl_desc in ('Complete New Enrollment - CHOICES Group 1',
            'Complete New Enrollment - CHOICES Group 3')) 
update perlss.tmg_task d
set enr_id = sq.enr_id
from sq where d.pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV')
   and d.task_dtl_desc in ('Complete New Enrollment - CHOICES Group 1',
            'Complete New Enrollment - CHOICES Group 3')
			
			
delete scripts for task

select * from perlss.enr_rqst where created_by ='PASRR_CV' and enr_status_cd in ('NEE','MOP','PFE')

select * from perlss.tmg_task 
where pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV');

select * from perlss.tmg_doc
where pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV');

select * from perlss.com_work_flow_analytics
where pasrr_id is not null and action_type_cd ='TASK';


delete from perlss.com_work_flow_analytics 
where task_id in (select task_id from perlss.tmg_task 
where pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV'));

delete from perlss.tmg_task 
where pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV');

delete from perlss.tmg_doc
where pae_id in (select pae_id from perlss.cnv_task where created_by ='PASRR_CV');

delete from perlss.enr_rqst where created_by ='PASRR_CV' and enr_status_cd in ('NEE','MOP','PFE');

select * from legacy.ecf_recipients_20250306; --6136
select * from legacy.ch3a_recipients_20250306; --3651
select * from legacy.kb_recipients_20250306; --4835

update perlss.adj_pasrr_outcome 
set 
pasrr_id = NULL ,
episode_id = NULL, 
last_modified_by=NULL, 
lvl1_eff_dt = NULL  ,
lvl2_dcsn_dt = NULL, 
source_cd= null,
type_cd= null,
lvl1_end_dt= null,
link_sw=NULL
   where last_modified_by ='PASRR_CV';
   
   with sq as (
select distinct b.upload_dt  ,b.attachment_type , b.prsn_id , c.pasrr_id 
from perlss.int_pasrr_doc_sync_stg b 
join  perlss.doc_module_mapping a on a.doc_type = b.attachment_type   and a.prsn_id =b.prsn_id 
join perlss.pasrr_rqst c on c.pasrr_id = a.pasrr_id  and a.prsn_id = c.prsn_id and c.episode_id::text = b.review_id::text
where a.created_by = 'IN-RCPSRRDOCSYNC-DLY' and B.last_modified_by = 'IN-RCPSRRDOCSYNC-DLY') 
update perlss.doc_module_mapping p
set created_dt = sq.upload_dt
from sq where sq.attachment_type = p.doc_type 
and sq.pasrr_id =p.pasrr_id and sq.prsn_id = p.prsn_id
and p.created_by = 'IN-RCPSRRDOCSYNC-DLY';
   
   
   
   ADJ ID        end DT     start dt
100114677	2024-01-11	2023-11-27
100114747	2024-03-11	2024-03-05
100115256	2025-03-24	2024-12-24
100115256	2025-03-24	2024-12-24
100115292	2025-01-27	2025-01-07

legacy_id	adj_id	rqst_end_dt	rqst_eff_dt	srvc_name_cd
712634	100,114,677	2023-01-11	2023-11-27	OCT
753354	100,114,747	2024-03-05	2024-03-11	PHT
852071	100,115,256	2024-03-24	2024-12-24	OCT
852071	100,115,256	2024-03-24	2024-12-24	PHT
856083	100,115,292	2023-01-07	2025-01-27	PHT


update perlss.adj_skilled_srvcs set rqst_eff_dt ='2023-11-27' ,rqst_end_dt ='2024-01-11' where created_by ='PASRR_CV' and adj_id = 100114677 and srvc_name_cd = 'OCT';
update perlss.adj_skilled_srvcs set rqst_eff_dt ='2024-03-05' ,rqst_end_dt ='2024-03-11' where created_by ='PASRR_CV' and adj_id = 100114747 and srvc_name_cd = 'PHT';
update perlss.adj_skilled_srvcs set rqst_eff_dt ='2024-12-24' ,rqst_end_dt ='2025-03-24' where created_by ='PASRR_CV' and adj_id = 100115256  and srvc_name_cd = 'OCT';
update perlss.adj_skilled_srvcs set rqst_eff_dt ='2024-12-24' ,rqst_end_dt ='2025-03-24' where created_by ='PASRR_CV' and adj_id = 100115256  and srvc_name_cd = 'PHT';
update perlss.adj_skilled_srvcs set rqst_eff_dt ='2025-01-07' ,rqst_end_dt ='2025-01-27' where created_by ='PASRR_CV' and adj_id = 100115292 and srvc_name_cd = 'PHT';


update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='2023-11-27' ,rqstd_end_dt ='2024-01-11' where created_by ='PASRR_CV' and PAE_ID = 'PAE200113519' and section_type_cd = 'OCT';
update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='2024-03-05' ,rqstd_end_dt ='2024-03-11' where created_by ='PASRR_CV' and PAE_ID = 'PAE200113589' and section_type_cd = 'PHT';
update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='2024-12-24' ,rqstd_end_dt ='2025-03-24' where created_by ='PASRR_CV' and PAE_ID = 'PAE200114098'  and section_type_cd = 'OCT';
update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='2024-12-24' ,rqstd_end_dt ='2025-03-24' where created_by ='PASRR_CV' and PAE_ID = 'PAE200114098'  and section_type_cd = 'PHT';
update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='2025-01-07' ,rqstd_end_dt ='2025-01-27' where created_by ='PASRR_CV' and PAE_ID = 'PAE200114134' and section_type_cd = 'PHT';


update perlss.pae_skilled_srvc_dtl set rqstd_start_dt ='' ,rqstd_end_dt =''
where created_by ='PASRR_CV' and pae_id =  and section_type_cd = '';

with sq as (
select distinct b.upload_dt  ,b.attachment_type , b.prsn_id , c.pasrr_id 
from perlss.int_pasrr_doc_sync_stg b 
join  perlss.doc_module_mapping a on a.doc_type = b.attachment_type   and a.prsn_id =b.prsn_id 
join perlss.pasrr_rqst c on c.pasrr_id = a.pasrr_id  and a.prsn_id = c.prsn_id and c.episode_id::text = b.review_id::text
where a.created_by = 'IN-RCPSRRDOCSYNC-DLY' and B.last_modified_by = 'IN-RCPSRRDOCSYNC-DLY') 
update perlss.doc_module_mapping p
set created_dt = sq.upload_dt
from sq where sq.attachment_type = p.doc_type 
and sq.pasrr_id =p.pasrr_id and sq.prsn_id = p.prsn_id
and p.created_by = 'IN-RCPSRRDOCSYNC-DLY';

with sq as (
select a.prsn_id , a.pae_id , b.entity_id  from perlss.tmg_task a
join perlss.pae_rqst b on a.pae_id =b.pae_id and a.prsn_id = b.prsn_id
where 1=1--a.created_dt ::date ='2025-03-11'
and b.created_by ='PASRR_CV'
and a.entity_id ='842' and a.task_dtl_desc ='Add Group 3 Interest Details') 
update perlss.tmg_task p
set entity_id = sq.entity_id
from sq where p.prsn_id = sq.prsn_id and p.pae_id = sq.pae_id and 
p.entity_id ='842' and p.task_dtl_desc ='Add Group 3 Interest Details';