package body Log_Filter is

   
   procedure select_file(p_file : String) is
   begin
      
      Open (File => File,
            Mode => In_File,
            Name => p_file);
      
   end select_file;
   
   procedure set_filters is 
      
      input_line : String (1 .. 1000);
      input_last : Natural;
      number_of_filters : Natural := 1;
      
   begin
      
      Put("Enter filters : ");
      Get_Line(input_line, input_last);
      Put_Line ("");
      
      
      for I in 1 .. input_last loop
         
         if input_line(I) = ' '  AND I /= 1 then
            
            if input_line(I-1) /= ' ' then
               
               number_of_filters := number_of_filters +1;
               
            end if;
             
            if I = input_last AND input_line(I) = ' ' then
               
               number_of_filters := number_of_filters -1;
               
            end if;
            
         end if;      
      
      end loop;
      
      create_filters(number_of_filters, input_line, input_last);
      
   end set_filters;
   
   procedure create_filters (p_number_of_filters : Natural; p_input_line : String; p_input_last : Natural) is
      
      subtype array_column_control is
        Natural range 1 .. p_number_of_filters;
      
      subtype array_line_control is
        Natural range 1 .. 40;   
      
      filters : store_filter(1 .. 40, 1..p_number_of_filters);
      array_column_position : array_column_control := 1; 
      array_line_position : array_line_control := 1; 
      
   begin 
      Put_Line("CREATE FILTER");
      for I in 1 .. p_input_last loop
         
         if p_input_line(I) /= ' ' then
            
            --It seems like Put(filter(x,y)) prevent the program to display anything... Strange.
            --To_lower returns a character sent in parameter in lower case.
            filters(array_line_position, array_column_position) := To_Lower(p_input_line(I)); 
           
            array_line_position := array_line_position + 1;  
            
            if I = p_input_last then
               
               filters(array_line_position, array_column_position) := '|';
               
            end if;
            
         elsif p_input_line(I) = ' ' AND I /= 1 then
           
            filters(array_line_position, array_column_position) := '|';
            array_line_position := 1;
            
            if array_column_position < p_number_of_filters then
               
               array_column_position := array_column_position + 1;
            
            end if;
            
         end if;
                  
      end loop;
      
      read_line(filters, p_number_of_filters);
            
   end create_filters;
   
   procedure display_line is
   begin
      
      Text_IO.Unbounded_IO.Put_Line(line);
      
   end display_line;
   
   procedure initialize_filter_state (p_value : Boolean; p_filter_state : in out store_Filter_State) is
   begin
      
      for I in p_filter_state'Range loop
      
         p_filter_state(I) := p_value;
         
      end loop;
      
      
   end initialize_filter_state;
   
   function are_they_all_true (p_filter_state : store_Filter_State) return Boolean is
         
   begin
   
      for I in p_filter_state'Range loop
         
         if p_filter_state(I) = false then
            
            return false;
            
         end if;
      
      end loop;
      
      return true;
      
   end are_they_all_true;
   

   procedure read_line (p_filters : store_Filter; p_number_of_filters : Natural) is
      word : string (1..40); 
      word_length : Natural := 0;
      line_to_display : Boolean := false;
      filter_state : store_Filter_State (1.. p_number_of_filters);
   begin
      While not  End_Of_File (file) Loop
         
         line := To_Unbounded_String(Get_Line(file));
         initialize_filter_state(p_value => false, p_filter_state => filter_state);
         
         for I in 1..Length(line) loop
            
            
            -- It reads the line character by character
            -- and write each word into word (variable)
            -- then compare it with the filters
            -- then repeat until the end of line
            
            if Element(line,I) /= ' ' and End_Of_Line(file) = false then
               
               if Element(line,I) /= '[' AND Element(line,I) /= '(' AND Element(line,I) /=''' 
                 AND Element(line,I) /='"' AND Element(line,I) /='<' AND Element(line,I) /='{' then
                  
                  word_length := word_length + 1;
                  word (word_length) := To_Lower(Element(line,I));
                  
               end if;
                  
            elsif Element(line,I) = ' ' or End_Of_Line(file) = true then
               
               filter_check(p_filters, p_number_of_filters, word, filter_state);
               word_length := 0;
                 
            end if;

           
         end loop;
         
         if are_they_all_true(filter_state) = true then
            
            display_line;
            
         end if;
         
      end loop;
      close(file);
   end read_line;  
   
   
   procedure filter_check(p_filters : store_Filter; p_number_of_filters : Natural; p_word : String; p_filter_state : in out store_Filter_State) is

      are_characters_identical : Boolean := true;
      
   begin
      
      for I in 1 .. p_number_of_filters loop
         
         are_characters_identical := true;

         for Y in 1 .. 40 loop

            if are_characters_identical = true then
               
               if p_filters(Y,I) /= p_word(Y) AND p_filters(Y,I) /= '|' then
                  
                  are_characters_identical := false;
                  
               elsif p_filters(Y,I) = '|' AND are_characters_identical = true then
                  
                  p_filter_state(I) := true;
                  
               end if;
            
            end if;
         end loop;
         
         
      end loop;
      
   end filter_check;
   
   
end Log_Filter;
