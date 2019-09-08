package body Log_Filter is

----------------------------------------------------------   
   
   procedure Create_Filters (P_Number_Of_Filters    : Natural;
                             P_User_Filters_Input   : String;
                             P_Last_Inputs_Position : Natural) is
      
      subtype array_column_control is
        Natural range 1 .. p_number_of_filters; 
      
      subtype array_line_control is
        Natural range 1 .. 40;   
      
      filters          : store_filter (1 .. 40, 1..p_number_of_filters);
      Columns_Position : array_column_control := 1; 
      Lines_Position   : array_line_control   := 1; 
      
   begin 
            
      for I in 1 .. P_Last_Inputs_Position loop
         
         if P_User_Filters_Input (I) /= ' ' then
                        
            --  We use To_Lower to store filters in lower case in a variable.
              --  So we won't miss the word carl because the user entered Carl.
            
            filters (Lines_Position, Columns_Position) :=
              To_Lower (P_User_Filters_Input (I)); 
           
            Lines_Position := Lines_Position + 1;  
            
            if I = P_Last_Inputs_Position then
               
               filters (Lines_Position, Columns_Position) := '|';
               
            end if;
            
         elsif P_User_Filters_Input (I) = ' ' and I /= 1 then
            
            if P_User_Filters_Input (I-1) /= ' ' then
           
               filters (Lines_Position, Columns_Position) := '|';
               Lines_Position                             := 1;
            
               if Columns_Position < p_number_of_filters then
               
                  Columns_Position := Columns_Position + 1;
                  
               end if;
            end if;
         end if;
                  
      end loop;
      
      Read_File (filters, p_number_of_filters);
            
   end create_filters;

----------------------------------------------------------   

   procedure Update_Lines is
   begin
      
      Lines       := Lines & line & ASCII.LF;
      Lines_Count := Lines_Count + 1;
      
   end Update_Lines;

----------------------------------------------------------      

   procedure Filter_Check (P_Filters           :        store_Filter;
                           P_Number_Of_Filters :        Natural;
                           P_Word              :        String;
                           P_Filters_State     : in out store_Filters_State) is

      are_characters_identical : Boolean := true;
      
   begin
      
      for I in 1 .. p_number_of_filters loop
         
         are_characters_identical := true;

         for Y in 1 .. 40 loop
                        
            if are_characters_identical = true then
               
               if p_filters (Y,I) /= p_word (Y) 
                 and p_filters (Y,I) /= '|'          then
                  
                  are_characters_identical := false;
                  
               elsif p_filters (Y,I) = '|'   
                 and are_characters_identical = true then
               
                  p_Filters_State (I) := true;
                  
               end if;
            
            end if;
            
         end loop;
         
         
      end loop;
      
   end Filter_Check;   
 
----------------------------------------------------------         

   procedure Initialize_Filters_State (p_value         :         Boolean;
                                       p_Filters_State : in out store_Filters_State) is
   begin
      
      for I in p_Filters_State'Range loop
      
         p_Filters_State (I) := p_value;
         
      end loop;
      
      
   end Initialize_Filters_State;
 
----------------------------------------------------------            

   procedure Read_File (P_Filters           : store_Filter;
                        P_Number_Of_Filters : Natural) is
      
      
      Filters_State   : store_Filters_State (1.. p_number_of_filters);
      
   begin
      While not End_Of_File(file) Loop
         
         Line := To_Unbounded_String (Get_Line(file) );
         Line := Line & " ";
         
         Initialize_Filters_State (P_Value         => false,
                                   p_Filters_State => Filters_State);
         
         Read_Line(P_Filters           => P_Filters,
                   P_Number_Of_Filters => P_Number_Of_Filters,
                   P_Filters_State     => Filters_State);
         
         if are_they_all_true (Filters_State) = true then
            
            Update_Lines;
            
         end if;
         
      end loop;
      
      close (file);
   
   end Read_File;  
   
----------------------------------------------------------            
   
   procedure Read_Line (P_Filters           :        Store_Filter;
                        P_Number_Of_Filters :        Natural;
                        P_Filters_State     : in out Store_Filters_State) is
   
      Word_Length : Natural := 0;
      Word        : string (1 .. 100); 
   
   begin
      
      for I in 1 .. Length (line) loop
            
            
            --  We ignore some opening characters to not miss any information
             --in logs.
              -- Therefore, a user doesn't need to think about logs syntax.
               --  So it avoids [carl not being returned when carl is a filter.
            
            
         if Element (line,I) /= ' '  then
               
            if    Element (line,I) /= '[' 
              and Element (line,I) /= '(' 
              and Element (line,I) /= ''' 
              and Element (line,I) /= '"' 
              and Element (line,I) /= '<'
              and Element (line,I) /= '*'
              and Element (line,I) /= '{' then
                  
               word_length        := word_length  +  1;
               word (word_length) := To_Lower (Element(line,I));
                  
            end if;
                  
         elsif Element (line,I) = ' ' or End_Of_Line (file) = true then
               
            Filter_Check (P_filters           => P_filters,
                          P_number_of_filters => P_number_of_filters,
                          P_word              => word,
                          P_Filters_State     => P_Filters_State);
            Word_Length := 0;
               
         end if;
    
      end loop;
      
   end Read_Line;
  
----------------------------------------------------------            
   
   procedure Select_File (p_file : String) is
   begin
      
      if Is_Open (File) = False then
      
         Open (File => File,
            Mode => In_File,
            Name => p_file);
      
      end if;
      
   exception 
      when Ada.Text_IO.Name_Error =>
           Ada.Text_IO.Put_Line (File => Ada.Text_IO.Standard_Error,
                                 Item => "Can't open file!");
      
      
   end Select_File;
   
----------------------------------------------------------            
   
   procedure Close_File is
   begin
   
      if Is_Open (File) = True then
      
         Close(File);
      
      end if;
         
         
   end Close_File;
   
----------------------------------------------------------            

   procedure Set_Filters (P_Filters : String) is 
      
      Last_Inputs_Position : Natural;
      Number_Of_Filters    : Natural := 1;
      
   begin
      
      Last_Inputs_Position := P_Filters'Last;
      
      for I in 1 .. Last_Inputs_Position loop
         
         if P_Filters (I) = ' '  and I /= 1 then
            
            if P_Filters (I-1) /= ' ' then
               
               Number_Of_Filters := Number_Of_Filters +1;
               
            end if;
             
            if I = Last_Inputs_Position and P_Filters(I) = ' ' then
               
               Number_Of_Filters := Number_Of_Filters -1;
               
            end if;
            
         end if;      
      
      end loop;
      
      Create_Filters (Number_Of_Filters, P_Filters, Last_Inputs_Position);
      
   end Set_Filters;
----------------------------------------------------------               

   procedure Reset_Lines is
   
   begin
      
      Lines := To_Unbounded_String("");
   end Reset_Lines;
   
----------------------------------------------------------               
   
   procedure Reset_Lines_Count is
   
   begin
   
      Lines_Count := 0;
      
   end Reset_Lines_Count;
   
----------------------------------------------------------               
   
   function Are_They_All_True (P_Filters_State : Store_Filters_State) 
     return Boolean is
         
   begin
   
      for I in P_Filters_State'Range loop
         
         if P_Filters_State (I)  =  false then
            
            return false;
            
         end if;
      
      end loop;
      
      return true;
      
   end Are_They_All_True;

----------------------------------------------------------               

   function Get_Lines
     return String is
      
   begin
      
      return To_String (Lines);
      
   end Get_Lines;
   
----------------------------------------------------------
 
   function Get_File_Name
     return String is
   
   begin
      
      return Name (File);
      
   end Get_File_Name;
   
----------------------------------------------------------
   
   function Get_Lines_Count
     return Integer is
      
   begin
      
      return Lines_Count;
      
   end Get_Lines_Count;
      
end Log_Filter;





