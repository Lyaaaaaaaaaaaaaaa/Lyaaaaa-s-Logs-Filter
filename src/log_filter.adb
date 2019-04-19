package body Log_Filter is

   
   procedure select_file(p_file : String) is
   begin
      
      Open (File => File,
            Mode => In_File,
            Name => p_file);
      
   end select_file;
   

   
   procedure display_line is
   begin
      
      Text_IO.Unbounded_IO.Put_Line(line);
      
   end display_line;
   
   procedure read_line is
      word : string (1..40); 
      word_length : Natural := 1;
      line_to_display : Boolean := false;
   begin
      
      While not  End_Of_File (file) Loop
         
         line := To_Unbounded_String(Get_Line(file));
         
         for I in 1..Length(line) loop
            
            
            -- It reads the line character by character
            -- and write each word into word (variable)
            -- then compare it with the filters
            -- then repeat until the end of line
            
            
            if Element(line,I) /= ' ' and End_Of_Line(file) = false then
            
               word (word_length) := Element(line,I);
               word_length := word_length + 1;
            elsif Element(line,I) = ' ' or End_Of_Line(file) = true then
               word_length := 1;
               
               if filter_check = true then
                  line_to_display := true;
               else
                  line_to_display := false;
               end if;
               
            end if;
         
           
         end loop;
         
         if line_to_display = true then
            display_line;
         end if;
         
      end loop;
      close(file);
   end read_line;  
   
   
   function filter_check return Boolean is
   begin
      return true; --until now, true for test.
      -- WIP Area
   end filter_check;
      

end Log_Filter;
