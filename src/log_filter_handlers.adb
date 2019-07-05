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
         Filename => "interface/Interface_no_icon.glade",
         Error    => Error'Access);  
      
      if Error /= null then
         Ada.Text_IO.Put_Line ("Error : " & Get_Message (Error));
         Error_Free (Error);
         return;
      end if;

      Do_Connect (Builder);
      Main_Window          := Gtk_Window       (Builder.Get_Object
                                                ("Main_Window"));
      Button               := Gtk_Button       (Builder.Get_Object 
                                                ("Button_Start"));
      Filters_Entry        := Gtk_Entry_Buffer (Builder.Get_Object
                                                ("Entry_Filter_Input_Buffer"));
      Application_Output   := Gtk_Text_Buffer  (Builder.Get_Object
                                                ("Text_View_Output_Buffer"));

   end Connect_Interface;

----------------------------------------------------------

   procedure Register_Handlers is
   begin

      Button.On_Clicked      (Button_Start_Clicked'Access);
      Main_Window.On_Destroy (Quit'Access);
      

   end Register_Handlers;
----------------------------------------------------------
   
   procedure Start_Interface is
   begin

      Gtk.Widget.Show_All (Gtk_Widget (Gtkada.Builder.Get_Object
                                       (Builder, "Main_Window")));
      Gtk.Main.Main;

   end Start_Interface;

----------------------------------------------------------

   procedure Quit (Self : access Gtk_Widget_Record'Class) is
      
      
   
   begin

      Unref (Builder);      
      Gtk.Main.Main_Quit;

   end Quit;
   
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
      Log_Filter.Set_Filters       (Get_Text (Filters_Entry));
      Application_Output.Set_Text  (Text =>  Log_Filter.Get_Lines);
      
      Log_Filter.Reset_Lines;
      Log_Filter.Reset_Lines_Count;
      
   end Button_Start_Clicked;
   
----------------------------------------------------------             

   function Status_Message
     return String is
      
      Message : Unbounded_String;
      
   begin
      -- WIP AREA
      
      Message := To_Unbounded_String ("==== ")
               & To_Unbounded_String (Log_Filter.Get_Lines_Count)
        -- doesn't work, need to convert int into string
               & To_Unbounded_String (" Valid lines ====");
              
      
      return To_String (Message);
      
   end Status_Message;
   

end Log_Filter_Handlers;
