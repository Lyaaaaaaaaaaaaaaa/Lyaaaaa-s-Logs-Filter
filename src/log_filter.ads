----------------------------------------------------------
-- Copyright (c), The MIT License (MIT)
-- Author: Lyaaaaaaaaaaaaaaa
--
-- Revision History:
--   18/09/2019 Lyaaaaaaaaaaaaaaa
--    - Added file header
--    - Filter_Check becomes Check_Filters
--
-- Encoding issues :
--  - Needs UTF-8 encoded files,
--     otherwise it will return wrong data.
--
-- Limitations :
--  - Filters can't be longer than 40 characters.
--     See array_line_control 's range in Create_Filters.
--     See Filters in Create_Filters and its subtype. 
----------------------------------------------------------

with Text_IO;                 use Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;

----------------------------------------------------------

package Log_Filter is

 ----------------------------------------------------------  
   
   type Store_Filter is
     array (Natural range <>, Natural range <>) of Character;
   
   type Store_Filters_State is
     array (Natural range <>)                   of Boolean;
  
 ----------------------------------------------------------  
   
   --------------------------------------------
   --       Procedures and functions         --
   --------------------------------------------
   
   
   -------------------
   --    Filters    --
   -------------------
   
   procedure Create_Filters 
     (P_Number_Of_Filters    :        Natural;
      P_User_Filters_Input   :        String;
      P_Last_Inputs_Position :        Natural);
    -- Inserts into 2D table "Store_Filter" input words in lower case.
     -- Calls Read_File
   
   procedure Check_Filters 
     (P_Filters              :        store_Filter;
      P_Number_Of_Filters    :        Natural;
      P_Word                 :        String;
      P_Filters_State        : in out store_Filters_State);
    -- Compares each filter with the words in current line. 
   
   procedure Initialize_Filters_State 
     (P_Value                :        Boolean;
      P_Filters_State        : in out Store_Filters_State);  
   
   procedure Set_Filters 
     (P_Filters              :        String);
    -- Counts the received filters and calls Create_Filters
   
   -----------------
   --    Lines    --
   -----------------   
   
   procedure Update_Lines;
    -- Updates Lines and Lines_Count.
   
   procedure Read_Line 
     (P_Filters              :        Store_Filter;
      P_Number_Of_Filters    :        Natural;
      P_Filters_State        : in out Store_Filters_State);
    -- Reads Line character by character and inserts them into strings "Word"
     -- Then, calls Check_Filters.    
   
   procedure Reset_Lines;
   
   procedure Reset_Lines_Count;
   
   function Get_Lines
     return String;
   
   function Get_Lines_Count
     return Integer; 

   
   ----------------
   --    File    --
   ----------------   
   
   procedure Read_File 
     (P_Filters              :        Store_Filter;
      P_Number_Of_Filters    :        Natural);
    -- Inserts into Line the current line from the selected file.
     -- Calls Initialize_Filters_State and Read_Line,
     -- then checks Filter_State and calls Update_Lines.
   
   procedure Select_File 
     (P_File                 :        String);
   
   procedure Close_File;
   
   function Get_File_Name
     return String;
 
   -----------------
   --    Other    --
   -----------------    
   
   function Are_They_All_True 
     (P_Filters_State        :        Store_Filters_State)
     return Boolean;     

   
end Log_Filter;
