with Text_IO; use Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;

package Log_Filter is

   -- ===== Variables declaration ====================
   
   file : File_Type;
   line : Unbounded_String;
   
   type Store_Filter is
     array (Natural range <>, Natural range <>) of Character;
   
   --  I created this custom type to store in memory if our filters appear in the.
   type Store_Filters_State is
     array (Natural range <>) of Boolean;
   
   
   -- ===== functions and procedures declaration =====
   -- I'm using P_variable for parameters name.
   
   procedure Create_Filters (P_Number_Of_Filters    : Natural;
                             P_User_Filters_Input   : String;
                             P_Last_Inputs_Position : Natural);
   
   procedure Display_Line;
   
   procedure Filter_Check (P_Filters           :        store_Filter;
                           P_Number_Of_Filters :        Natural;
                           P_Word              :        String;
                           P_Filters_State     : in out store_Filters_State);
   
   procedure Initialize_Filters_State (P_Value         :        Boolean;
                                       P_Filters_State : in out Store_Filters_State);
   
   procedure Read_File (P_Filters           :  Store_Filter;
                        P_Number_Of_Filters :  Natural);
   
   procedure Read_Line (P_Filters           :        Store_Filter;
                        P_Number_Of_Filters :        Natural;
                        P_Filters_State     : in out Store_Filters_State);
   
   procedure Select_File (P_File : String);
   
   procedure Set_Filters;

   function Are_They_All_True (P_Filters_State : store_Filters_State)
     return Boolean; 
   
   
end Log_Filter;
