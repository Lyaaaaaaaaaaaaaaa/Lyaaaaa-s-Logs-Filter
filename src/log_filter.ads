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
   
   procedure create_filters (P_Number_Of_Filters    : Natural;
                             P_User_Filters_Input   : String;
                             P_Last_Inputs_Position : Natural);
   
   procedure display_line;
   
   procedure filter_check (P_Filters           :        store_Filter;
                           P_Number_Of_Filters :        Natural;
                           P_Word              :        String;
                           P_Filters_State     : in out store_Filters_State);
   
   procedure initialize_Filters_State (P_Value         :        Boolean;
                                       P_Filters_State : in out store_Filters_State);
   
   procedure read_line (P_Filters           :  store_Filter;
                        P_Number_Of_Filters :  Natural);
   
   procedure select_file (P_File : String);
   
   procedure set_filters;

   function are_they_all_true (P_Filters_State : store_Filters_State)
     return Boolean; 
   
   
end Log_Filter;
