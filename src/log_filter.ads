with Text_IO;                 use Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;

package Log_Filter is

   -- ===== Variables declaration ====================
   
   File        : File_Type;
   Line        : Unbounded_String;
   Lines       : Unbounded_String;
   Lines_Count : Integer;
   
   type Store_Filter is
     array (Natural range <>, Natural range <>) of Character;
   
   type Store_Filters_State is
     array (Natural range <>)                   of Boolean;
   
   
   -- ===== functions and procedures declaration =====
   
   procedure Create_Filters 
     (P_Number_Of_Filters    :        Natural;
      P_User_Filters_Input   :        String;
      P_Last_Inputs_Position :        Natural);
   
   procedure Display_Line;
   
   procedure Filter_Check 
     (P_Filters              :        store_Filter;
      P_Number_Of_Filters    :        Natural;
      P_Word                 :        String;
      P_Filters_State        : in out store_Filters_State);
   
   procedure Initialize_Filters_State 
     (P_Value                :        Boolean;
      P_Filters_State        : in out Store_Filters_State);
   
   procedure Read_File 
     (P_Filters              :        Store_Filter;
      P_Number_Of_Filters    :        Natural);
   
   procedure Read_Line 
     (P_Filters              :        Store_Filter;
      P_Number_Of_Filters    :        Natural;
      P_Filters_State        : in out Store_Filters_State);
   
   procedure Select_File 
     (P_File                 :        String);
   
   procedure Set_Filters 
     (P_Filters              :        String);
   
   procedure Reset_Lines;
   
   procedure Reset_Lines_Count;
   
   function Are_They_All_True 
     (P_Filters_State        :        Store_Filters_State)
     return Boolean; 
   
   function Get_Lines
     return String;
   
   function Get_Lines_Count
     return Integer;
   
end Log_Filter;
