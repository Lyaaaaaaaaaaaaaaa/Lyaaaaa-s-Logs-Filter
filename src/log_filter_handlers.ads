with Gtk.Main;
with Gtk.Image;
with Gtkada.Builder;

with Gtk;                     use Gtk;
with Glib;                    use Glib;
with Gtk.Box;                 use Gtk.Box;
with Gtk.Main;                use Gtk.Main;
with Gtk.Label;               use Gtk.Label;
with Gtk.Button;              use Gtk.Button;
with Gtk.Widget;              use Gtk.Widget;
with Glib.Error;              use Glib.Error;
with Gtk.Window;              use Gtk.Window;
with Gtk.Spinner;             use Gtk.Spinner;
with Gtk.Text_Iter;           use Gtk.Text_Iter;
with Gtk.Text_View;           use Gtk.Text_View;
with Gtk.Assistant;           use Gtk.Assistant;
with Gtk.Menu_Item;           use Gtk.Menu_Item;
with Gtkada.Builder;          use Gtkada.Builder;
with Gtk.Text_Buffer;         use Gtk.Text_Buffer;
with Gtkada.Handlers;         use Gtkada.Handlers;
with Gtk.Entry_Buffer;        use Gtk.Entry_Buffer;
with Gtkada.File_Selection;   use Gtkada.File_Selection;


--With Gtk.File_Chooser;        use Gtk.File_Chooser;
--with Gtk.File_Chooser_Button; use Gtk.File_Chooser_Button;
--with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;


with Ada.Text_IO;
with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
-- Don't forget to delete the useless inclusions.
-- Custom include

with Log_Filter;              use Log_Filter;

package Log_Filter_Handlers is
   -- Init GtkAda, connect the interface file with the package
   -- Connect the signals with the handlers.

   Error                : aliased Glib.Error.GError;
   Button_Start         :         Gtk_Button;
   Builder              :         Gtkada_Builder;
   Return_Code          :         Guint;
   Main_Window          :         Gtk_Window;
   Filters_Entry        :         Gtk_Entry_Buffer;
   Application_Output   :         Gtk_Text_Buffer;
   Button_Select_File   :         Gtk_Button;
   Retour               :         Unbounded_String;
   Help_Assistant       :         Gtk_Assistant;
   Help_Menu_Item       :         Gtk_Menu_Item;
--   File_Chooser_Button  :         Gtk_File_Chooser_Button;
--   File_Chooser_Dialog  :         Gtk_File_Chooser_Dialog;

   procedure Init;
    -- Init will Initialize GTKAda and create the objetcs.

   procedure Connect_Interface;
    -- Will load the interface xml file
     -- and link the objects declared ealier
     -- to the widget of the xml file.

   procedure Register_Handlers;
    -- Links Gtk's signals with the Log_Filter_Handlers.

--   procedure Init_Objects;
--   -- Set up the parameters of the objects.

   procedure Start_Interface;
    -- Display the main window and start gtk's loop.

   procedure Quit
     (Self              : access Gtk_Widget_Record'Class);
    -- Unreference the builder and shutdown the application.


   -----------------
   --   Buttons   --
   -----------------

   procedure Button_Start_Clicked
     (Self              : access Gtk_Button_Record'Class);
    -- The "Start" button handler. Calls Log_Filter's methods.

   procedure Button_Select_File_Clicked
     (Self              : access Gtk_Button_Record'Class);
    -- WIP

   -------------------
   --   Assistant   --
   -------------------

   procedure Display_Help_Assistant
     (Self              : access Gtk_Menu_Item_Record'Class);
    -- Show the assistant dialog.

   procedure Display_Next_Page
     (Self              : access Gtk_Assistant_Record'Class);
    -- Will show the next page of the assistant.

   procedure Validate_Step
     (Self              : access Gtk_Entry_Buffer_Record'Class);
    -- will validate the step and unlock the "next" button.

   procedure Quit_Assistant
     (self              : access Gtk_Assistant_Record'Class);
    -- Hide the assistant dialog and unref it.


   -------------------
   --   Functions   --
   -------------------

   function Status_Message
     return String;
   --Will format a text with the number of lines checked, how many valid
    -- and the filters. WIP

end Log_Filter_Handlers;