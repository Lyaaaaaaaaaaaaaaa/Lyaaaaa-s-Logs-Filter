with Text_IO; use Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Integer_Text_IO;

package Log_Filter is

   -- ===== Variables declaration =====
   
   file : File_Type;
   line : Unbounded_String;
   
   type store_Filter is
     array (Natural range <>, Natural range <>) of Character;
   
   type store_Filter_State is
     array (Natural range <>) of Boolean;

   
   
   -- ===== functions and procedures declaration =====
 
   procedure select_file(p_file : String);
   procedure display_line;
   procedure read_line (p_filters : store_Filter; p_number_of_filters : Natural);
   procedure set_filters;
   procedure create_filters (p_number_of_filters : Natural; p_input_line : String; p_input_last : Natural);
   function filter_check (p_filters : store_Filter; p_number_of_filters : Natural; p_word : String; p_filter_state : in out store_Filter_State) return Boolean;   
   
end Log_Filter;
