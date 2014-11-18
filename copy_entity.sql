SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 1000
---------------------------------------------------------------------------------------------------- 
--  Copyright 1998-2012, Unitask Inc., All rights reserved.
--  Filename: copy_entity.sql
--  Date: 2012-02-09
--  Author: aporter
--
--  Description:
--  This script will copy an existing UMD Entity and assist you in quickly creating new UMD entities
--
--  Usage Format:
--  sqlplus apps/<pass> @copy_entity.sql <EBS User> <Existing Entity> <New Entity> 
--  
--  Example:
--  sqlplus apps/apps @copy_entity.sql SYSADMIN FILE FILE_VCS
--
----------------------------------------------------------------------------------------------------
-- 
-- Variables ...
--
DECLARE
   v_user_name         VARCHAR(100) := UPPER('&1');
   v_user_id           NUMBER := 0;
   v_old_entity_name   VARCHAR2(30) := UPPER('&2');
   v_old_entity_id     NUMBER := 0;
   v_new_entity_name   VARCHAR2(30) := UPPER('&3');
   v_new_entity_exists VARCHAR2(10);
   v_new_entity_id     NUMBER := 0;
   v_entity_ldr_param_id NUMBER := 0;
   CURSOR c_user_id IS
      SELECT user_id
        FROM FND_USER
       WHERE user_name = v_user_name;
   CURSOR c_old_entity_id IS
      SELECT entity_id
        FROM xxpck_entities
       WHERE entity_name = v_old_entity_name;
   CURSOR c_new_entity_exists IS
      SELECT 'X'
        FROM xxpck_entities
       WHERE entity_name = v_new_entity_name;
-- 
-- Let the Fun Begin ... 
-- 
BEGIN
   OPEN c_user_id;
   FETCH c_user_id INTO v_user_id;
   -- 
   -- Check to see if we have a valid EBS user Name/Id
   --
   IF (c_user_id%FOUND) THEN 
      DBMS_OUTPUT.PUT_LINE('Found FND_USER row for user name: '||v_user_name||' id: '||TO_CHAR(v_user_id));
      OPEN c_old_entity_id;
      FETCH c_old_entity_id into v_old_entity_id;
      -- 
      -- Check to see if we have an existing UMD Entity
      -- 
      IF (c_old_entity_id%FOUND) THEN 
         DBMS_OUTPUT.PUT_LINE('Found XXPCK_ENTITY row for UMD Entity: '||v_old_entity_name||' id: '||TO_CHAR(v_old_entity_id));
         OPEN c_new_entity_exists;
         FETCH c_new_entity_exists INTO v_new_entity_exists;
         -- 
         -- Check to see if the 'new' entity alreay exists
         -- 
         IF (c_new_entity_exists%FOUND) THEN 
            DBMS_OUTPUT.PUT_LINE('New UMD Entity [' || v_new_entity_name || '] already exists.  Exiting program.');
         ELSE     -- (c_new_entity_exists%FOUND)
            DBMS_OUTPUT.PUT_LINE('About to create new UMD Entity [' || v_new_entity_name || '].');
            -- 
            -- Time to get to work...
            ---
            -- Get the new Entity ID from the sequence number
            -- 
            SELECT xxpck_entities_s.nextval INTO v_new_entity_id FROM dual;
            dbms_output.put_line('New Id is '||v_new_entity_id||' ');
            if (v_new_entity_id > 0) then
               -- Time to get to work...
               INSERT INTO xxpck_entities
                             (entity_id,
                              entity_name,
                              loader_id,
                              user_defined_flag,
                              created_by,
                              creation_date,
                              last_updated_by,
                              last_update_date,
                              download_string,
                              upload_string,
                              freeze_definition,
                              notify_on_create,
                              notify_on_update,
                              create_dist_list,
                              update_dist_list,
                              compile_date,
                              description,
                              attribute_category,
                              attribute1,
                              attribute2,
                              attribute3,
                              attribute4,
                              attribute5,
                              attribute6,
                              attribute7,
                              attribute8,
                              attribute9,
                              attribute10,
                              attribute11,
                              attribute12,
                              attribute13,
                              attribute14,
                              attribute15,
                              pre_download_tp,
                              pre_download_string,
                              post_download_tp,
                              post_download_string,
                              pre_upload_tp,
                              pre_upload_string,
                              post_upload_tp,
                              post_upload_string,
                              vcs_flag,
                              vcs_action,
                              vcs_project_root,
                              vcs_project_path,
                              vcs_file_calc_formula) 
               SELECT v_new_entity_id,          -- entity_id
                         v_new_entity_name,        -- entity_name
                         loader_id,
                         'Y',                      -- user_defined_flag
                         v_user_id,                -- created_by
                         SYSDATE,                  -- creation_date
                         v_user_id,                -- last_updated_by
                         SYSDATE,                  -- last_update_date
                         download_string,
                         upload_string,
                         'N',                      -- freeze_definition
                         notify_on_create,
                         notify_on_update,
                         create_dist_list,
                         update_dist_list,
                         NULL,                     -- compile_date
                         description,
                         attribute_category,
                         attribute1,
                         attribute2,
                         attribute3,
                         attribute4,
                         attribute5,
                         attribute6,
                         attribute7,
                         attribute8,
                         attribute9,
                         attribute10,
                         attribute11,
                         attribute12,
                         attribute13,
                         attribute14,
                         attribute15,
                         pre_download_tp,
                         pre_download_string,
                         post_download_tp,
                         post_download_string,
                         pre_upload_tp,
                         pre_upload_string,
                         post_upload_tp,
                         post_upload_string,
                         vcs_flag,
                         vcs_action,
                         vcs_project_root,
                         vcs_project_path,
                         vcs_file_calc_formula
               FROM xxpck_entities
               WHERE entity_id = v_old_entity_id;
               -- Process the lines...
               INSERT INTO xxpck_entity_ldr_params
                             (entity_ldr_param_id,
                              entity_id,
                              param_name,
                              required,
                              user_enabled,
                              created_by,
                              creation_date,
                              last_updated_by,
                              last_update_date,
                              assigment_type,
                              value_set,
                              default_value) 
               SELECT xxpck_entity_ldr_params_s.nextval,  -- entity_ldr_param_id
                         v_new_entity_id,                    -- entity_id
                         param_name,
                         required,
                         user_enabled,
                         v_user_id,                          -- created_by
                         SYSDATE,                            -- creation_date
                         v_user_id,                          -- last_updated_by
                         SYSDATE,                            -- last_update_date
                         assigment_type,
                         value_set,
                         default_value
               from (
                    select *
                    FROM xxpck_entity_ldr_params
                    WHERE entity_id = v_old_entity_id
                    ORDER BY entity_ldr_param_id
               );
               --
               -- Inner order by query above is fix for sequence rules, see Oracle docs ...
               --
               -- We are done, save the work and put out a new message ...
               -- 
               COMMIT;
               DBMS_OUTPUT.PUT_LINE(' ');
               DBMS_OUTPUT.PUT_LINE('The new UMD Entity ' || v_new_entity_name || ' has been created!');
               DBMS_OUTPUT.PUT_LINE(' ');
               DBMS_OUTPUT.PUT_LINE('Next Steps:');
               DBMS_OUTPUT.PUT_LINE('1. Edit the New Entity');
               DBMS_OUTPUT.PUT_LINE('2. Change Description and other Metadata fields, but hold off on any functional changes till after verification');
               DBMS_OUTPUT.PUT_LINE('   PLEASE NOTE: Entity Descriptions are used for LOV -- Choose words accordingly!');
               DBMS_OUTPUT.PUT_LINE('3. Compile the New Entity before you can use it.');
               DBMS_OUTPUT.PUT_LINE('4. Logout/Login EBS');
               DBMS_OUTPUT.PUT_LINE('5. Verify Entity works just as the copied source entity');
               DBMS_OUTPUT.PUT_LINE('6. Modify the new entity as required . . .'); 
               DBMS_OUTPUT.PUT_LINE('7. Re-Compile as required . . .');
               DBMS_OUTPUT.PUT_LINE('8. Migrate the New Entity to the target EBS instance(s)');
               DBMS_OUTPUT.PUT_LINE(' ');
               DBMS_OUTPUT.PUT_LINE('Enjoy your new UMD Entity');
            ELSE     -- (v_new_entity_id%FOUND)
               DBMS_OUTPUT.PUT_LINE('Can''t get new entity id! ');
            END IF;  -- (v_new_entity_id%FOUND)
         END IF;  -- (c_new_entity_exists%FOUND)
         CLOSE c_new_entity_exists;
      ELSE     -- (c_old_entity_id%FOUND)
         DBMS_OUTPUT.PUT_LINE('Can''t file existing UMD Entity row for: ' || v_old_entity_name);
      END IF;  -- (c_old_entity_id%FOUND)
      CLOSE c_old_entity_id;
   ELSE     -- (c_user_id%FOUND)
      DBMS_OUTPUT.PUT_LINE('Can''t file FND_USER row for user name: ' || v_user_name);
   END IF;  -- (c_user_id%FOUND)
   CLOSE c_user_id;
   DBMS_OUTPUT.PUT_LINE(' ');
EXCEPTION
  when others then
     dbms_output.put_line('Error: '||sqlerrm||'');
     RAISE;
END;
/

