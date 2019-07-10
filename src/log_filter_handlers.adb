package body Log_Filter_Handlers is


   procedure Init is
   begin
   
       Gtk.Main.init;
       Gtk_New (Builder);

   end Init;

----------------------------------------------------------
  
   procedure Connect_Interface is
   begin
       
      Return_Code := Add_From_File 
        (Builder  => Builder,
         Filename => "interface/Interface.glade",
         Error    => Error'Access);  
      
      if Error /= null then
         Ada.Text_IO.Put_Line ("Error : " & Get_Message (Error) );
         Error_Free (Error);
         return;
      end if;

      Main_Window        := 
        Gtk_Window       (Builder.Get_Object ("Main_Window") );
      
      Button_Start       := 
        Gtk_Button       (Builder.Get_Object ("Button_Start") );
      
      Filters_Entry      := 
        Gtk_Entry_Buffer (Builder.Get_Object ("Entry_Filter_Input_Buffer") );
      
      Application_Output := 
        Gtk_Text_Buffer  (Builder.Get_Object ("Text_View_Output_Buffer") );
      
      Help_Assistant     :=
        Gtk_Assistant    (Builder.Get_Object ("Help_Assistant") );
      
      Help_Menu_Item     :=
        Gtk_Menu_Item    (Builder.Get_Object ("Menu_Item_Help") );
      
 --     Button_Select_File :=
   --     Gtk_Button       (Builder.Get_Object ("Button_Select_File") );
            
   end Connect_Interface;

----------------------------------------------------------

   procedure Register_Handlers is
   begin

      Button_Start.On_Clicked        (Button_Start_Clicked'Access);
      Main_Window.On_Destroy         (Quit'Access);
      Help_Menu_Item.On_Select       (Display_Help_Assistant'Access);
      Help_Assistant.On_Cancel       (Quit_Assistant'Access);
      Help_Assistant.On_Apply        (Display_Next_Page'Access);
      Help_Assistant.On_Close        (Quit_Assistant'Access);
      
      --Help_Assistant.On_Destroy     (Quit_Assistant'Access);
      --Button_Select_File.On_Clicked (Button_Select_File_Clicked'Access);
      
      

   end Register_Handlers;
----------------------------------------------------------

--   procedure Init_Objects is
--   begin

      
--   end Init_Objects;
   
   ----------------------------------------------------------
   
   procedure Start_Interface is
   begin

      Gtk.Widget.Show_All (Gtk_Widget (Gtkada.Builder.Get_Object
                                       (Builder, "Main_Window") ) );
      Gtk.Main.Main;

   end Start_Interface;

----------------------------------------------------------

   procedure Quit (Self : access Gtk_Widget_Record'Class) is
   begin

      Unref (Builder);      
      Gtk.Main.Main_Quit;

   end Quit;
 
----------------------------------------------------------            

   procedure Quit_Assistant (self : access Gtk_Assistant_Record'Class) is
   begin
      
      Help_Assistant.Hide;
      Help_Assistant.Unref;
      
   end Quit_Assistant;
     
----------------------------------------------------------            

   procedure Button_Start_Clicked 
     (Self                 : access Gtk_Button_Record'Class) is
      
      First_Iter : Gtk_Text_Iter;
      Last_Iter  : Gtk_Text_Iter;
      
   begin
      
      Application_Output.Get_Bounds(Start   => First_Iter,
                                    The_End => Last_Iter);
      
      Application_Output.Delete    (Start   => First_Iter,
                                    The_End => Last_Iter);
      
      Log_Filter.Select_File       ("./18th L.txt");
      Log_Filter.Set_Filters       (Get_Text (Filters_Entry) );
      Application_Output.Set_Text  (Text =>  Log_Filter.Get_Lines);
      
      Log_Filter.Reset_Lines;
      Log_Filter.Reset_Lines_Count;
      
   end Button_Start_Clicked;
   
----------------------------------------------------------             
   
   procedure Button_Select_File_Clicked
     (Self              : access Gtk_Button_Record'Class) is
   
   begin

      Retour := To_Unbounded_String
        (File_Selection_Dialog (Title       => "Select your file",
                                Default_Dir => "",
                                Dir_Only    => False,
                                Must_Exist  => True) );
      
   end Button_Select_File_Clicked;

----------------------------------------------------------             
   
   procedure Display_Help_Assistant
     (Self              : access Gtk_Menu_Item_Record'Class) is
   begin
      
      Help_Assistant.Show_All;
      
      for I in 0 .. Help_Assistant.Get_N_Pages loop
         
      
         Help_Assistant.Set_Page_Complete
           (Page     => Help_Assistant.Get_Nth_Page(I),
            Complete => True);
          -- auto complete steps.
    
      end loop;
   end Display_Help_Assistant;
   
----------------------------------------------------------   
   
   procedure Validate_Step
     (Self              : access Gtk_Entry_Buffer_Record'Class) is
   begin
   
         
      Help_Assistant.Set_Page_Complete 
        (Page     => Help_Assistant.Get_Nth_Page
         (Help_Assistant.Get_Current_Page),
         Complete => True);
         
   end Validate_Step;
   
----------------------------------------------------------             
   
   procedure Display_Next_Page
     (Self              : access Gtk_Assistant_Record'Class) is
   begin
      
      if Help_Assistant.Get_Current_Page < Help_Assistant.Get_N_Pages then
         
         Help_Assistant.Next_Page;
         
      end if;
      
   end Display_Next_Page;
   
----------------------------------------------------------             
   function Status_Message
     return String is
      
      Message : Unbounded_String;
      
   begin
      -- WIP AREA
      
      Message := 
          To_Unbounded_String ("==== ")
        & To_Unbounded_String (Log_Filter.Get_Lines_Count)
        -- doesn't work, need to convert int into string.
        & To_Unbounded_String (" Valid lines ====");
              
      
      return To_String (Message);
      
   end Status_Message;
   

end Log_Filter_Handlers;
