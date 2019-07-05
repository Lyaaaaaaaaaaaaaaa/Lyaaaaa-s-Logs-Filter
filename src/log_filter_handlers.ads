with Gtk.Main;
with Gtkada.Builder;
with Gtk.Button;              use Gtk.Button;
with Gtk;                     use Gtk;
with Gtk.Box;                 use Gtk.Box;

with Gtk.Label;               use Gtk.Label;
with Gtk.Text_Buffer;         use Gtk.Text_Buffer;
with Gtk.Widget;              use Gtk.Widget;

with Glib;                    use Glib;
with Glib.Error;              use Glib.Error;
with Gtk.Main;                use Gtk.Main;
with Gtk.Window;              use Gtk.Window;
with Gtk.Image;
with Gtkada.Builder;          use Gtkada.Builder;
with Gtkada.Handlers;         use Gtkada.Handlers;
with Gtk.Entry_Buffer;        use Gtk.Entry_Buffer;
with Gtk.Spinner;             use Gtk.Spinner;
with Gtk.Text_Iter;           use Gtk.Text_Iter;
with Gtk.Text_View;           use Gtk.Text_View;
with Gtk.File_Chooser_Button; use Gtk.File_Chooser_Button;
With Gtk.File_Chooser;        use Gtk.File_Chooser;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;

with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Ada.Text_IO;
-- Custom include

with Log_Filter;       use Log_Filter;

package Log_Filter_Handlers is
   -- Init GtkAda, connect the interface file with the package
   -- Connect the signals with the handlers.

   Builder              :         Gtkada_Builder;
   Error                : aliased Glib.Error.GError;
   Return_Code          :         Guint;
   Button               :         Gtk_Button;
   Filters_Entry        :         Gtk_Entry_Buffer;
   Application_Output   :         Gtk_Text_Buffer;
   Main_Window          :         Gtk_Window;
   File_Chooser_Button  :         Gtk_File_Chooser_Button;
   File_Chooser_Dialog  :         Gtk_File_Chooser_Dialog;


   procedure Init;
    -- Init will Initialize GTKAda and create the objetcs.

   procedure Connect_Interface;
    -- Will load the interface xml file
     -- and link the objects declared ealier
     -- to the widget of the xml file.

   procedure Register_Handlers;
    -- Links Gtk's signals with the Log_Filter_Handlers.

   procedure Start_Interface;
    -- Display the main window and start gtk's loop.

   procedure Quit (Self : access Gtk_Widget_Record'Class);
    -- Unreference the builder and shutdown the application

   procedure Button_Start_Clicked
     (Self                 : access Gtk_Button_Record'Class);
    -- The "Start" button handler

   function Status_Message
     return String;
   --Will format a text with the number of lines checked, how many valid
    -- and the filters.

end Log_Filter_Handlers;
