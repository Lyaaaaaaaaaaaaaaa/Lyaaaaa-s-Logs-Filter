package body Log_Filter is

----------------------------------------------------------   
   
   procedure Create_Filters (P_Number_Of_Filters    : Natural;
                             P_User_Filters_Input   : String;
                             P_Last_Inputs_Position : Natural) is
      
      subtype array_column_control is
        Natural range 1 .. p_number_of_filters; 
      
      subtype array_line_control is
        Natural range 1 .. 40;   
      
      filters          : store_filter(1 .. 40, 1..p_number_of_filters);
      Columns_Position : array_column_control := 1; 
      Lines_Position   : array_line_control   := 1; 
      
   begin 
            
      for I in 1 .. P_Last_Inputs_Position loop
         
         if P_User_Filters_Input(I) /= ' ' then
                        
            --  We use To_Lower to store filters in lower case in a variable.
              --  So we won't miss the word carl because the user entered Carl.
            
            filters (Lines_Position, Columns_Position) := To_Lower (P_User_Filters_Input(I)); 
           
            Lines_Position := Lines_Position + 1;  
            
            if I = P_Last_Inputs_Position then
               
               filters(Lines_Position, Columns_Position) := '|';
               
            end if;
            
         elsif P_User_Filters_Input(I) = ' ' and I /= 1 then
            
            if P_User_Filters_Input(I-1) /= ' ' then
           
               filters (Lines_Position, Columns_Position) := '|';
               Lines_Position := 1;
            
               if Columns_Position < p_number_of_filters then
               
                  Columns_Position := Columns_Position + 1;
                  
               end if;
            end if;
         end if;
                  
      end loop;
      
      Read_File (filters, p_number_of_filters);
            
   end create_filters;

----------------------------------------------------------   

   procedure Display_Line is
   begin
      
      Text_IO.Unbounded_IO.Put_Line (line);
      
   end display_line;

----------------------------------------------------------      

   procedure Filter_Check (p_filters           :        store_Filter;
                           p_number_of_filters :        Natural;
                           p_word              :        String;
                           p_Filters_State     : in out store_Filters_State) is

      are_characters_identical : Boolean := true;
      
   begin
      
      for I in 1 .. p_number_of_filters loop
         
         are_characters_identical := true;

         for Y in 1 .. 40 loop
                        
            if are_characters_identical = true then
               
               if p_filters(Y,I) /= p_word(Y) and p_filters(Y,I) /= '|'           then
                  
                  are_characters_identical := false;
                  
               elsif p_filters (Y,I) = '|'    and are_characters_identical = true then
               
                  p_Filters_State (I) := true;
                  
               end if;
            
            end if;
            
         end loop;
         
         
      end loop;
      
   end filter_check;   
 
----------------------------------------------------------         

   procedure Initialize_Filters_State (p_value         :         Boolean;
                                       p_Filters_State : in out store_Filters_State) is
   begin
      
      for I in p_Filters_State'Range loop
      
         p_Filters_State (I) := p_value;
         
      end loop;
      
      
   end initialize_Filters_State;
 
----------------------------------------------------------            

   procedure Read_File (P_Filters           : store_Filter;
                        P_Number_Of_Filters : Natural) is
      
      
      Filters_State   : store_Filters_State (1.. p_number_of_filters);
      
   begin
      While not End_Of_File(file) Loop
         
         line := To_Unbounded_String (Get_Line(file));
         
         initialize_Filters_State (P_Value         => false,
                                   p_Filters_State => Filters_State);
         
         Read_Line(P_Filters           => P_Filters,
                   P_Number_Of_Filters => P_Number_Of_Filters,
                   P_Filters_State     => Filters_State);
         
         if are_they_all_true (Filters_State) = true then
            
            display_line;
            
         end if;
         
      end loop;
      
      close (file);
   
   end Read_File;  
   
----------------------------------------------------------            
   
   procedure Read_Line (P_Filters           :        Store_Filter;
                        P_Number_Of_Filters :        Natural;
                        P_Filters_State     : in out Store_Filters_State) is
   
      word_length : Natural := 0;
      word        : string (1 .. 40); 
   
   begin
      
      for I in 1 .. Length(line) loop
            
            
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
               
            filter_check(p_filters           => p_filters,
                         p_number_of_filters => p_number_of_filters,
                         p_word              => word,
                         p_Filters_State     => P_Filters_State);
            word_length := 0;
               
         end if;
    
      end loop;
      
   end Read_Line;
  
----------------------------------------------------------            
   
   procedure Select_File (p_file : String) is
   begin
      
      Open (File => File,
            Mode => In_File,
            Name => p_file);
      
      
   exception 
      when Ada.Text_IO.Name_Error =>
           Ada.Text_IO.Put_Line(File => Ada.Text_IO.Standard_Error,
                                Item => "Can't open file!");
      
      
   end select_file;

----------------------------------------------------------            

   procedure Set_Filters is 
      
      User_Filters_Input          : String (1 .. 1000);
      Last_Inputs_Position        : Natural;
      number_of_filters : Natural := 1;
      
   begin
      
      Put ("Enter filters : ");
      Get_Line (User_Filters_Input, Last_Inputs_Position);
      Put_Line ("");
      
      
      for I in 1 .. Last_Inputs_Position loop
         
         if User_Filters_Input(I) = ' '  and I /= 1 then
            
            if User_Filters_Input(I-1) /= ' ' then
               
               number_of_filters := number_of_filters +1;
               
            end if;
             
            if I = Last_Inputs_Position and User_Filters_Input(I) = ' ' then
               
               number_of_filters := number_of_filters -1;
               
            end if;
            
         end if;      
      
      end loop;
      
      create_filters (number_of_filters, User_Filters_Input, Last_Inputs_Position);
      
   end set_filters;

----------------------------------------------------------               
   
   function Are_They_All_True (p_Filters_State : store_Filters_State) 
     return Boolean is
         
   begin
   
      for I in p_Filters_State'Range loop
         
         if p_Filters_State(I)  =  false then
            
            return false;
            
         end if;
      
      end loop;
      
      return true;
      
   end are_they_all_true;

----------------------------------------------------------               
   
end Log_Filter;
