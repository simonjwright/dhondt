with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Characters.Handling;
with Ada.Text_IO; use Ada.Text_IO;

procedure Dhondt_Calculator is
   type Party_Data is record
      Polling : Float;
      Number_Of_Seats : Natural := 0;
   end record;

   package Party_Maps is new Ada.Containers.Indefinite_Ordered_Maps
     (Element_Type => Party_Data,
      Key_Type => String);

   Parties : Party_Maps.Map;

   Number_Of_Seats : Positive;
begin
Get_Number_Of_Seats :
   loop
      declare
         Line : constant String := Get_Line;
      begin
         if Line'Length > 0 then
            begin
               Number_Of_Seats := Positive'Value (Line);
               exit Get_Number_Of_Seats;
            exception
               when Constraint_Error => null;
            end;
         end if;
      end;
   end loop Get_Number_Of_Seats;

Get_Party_Data :
   loop
      begin
         declare
            Line : constant String := Get_Line;
            Next_After_Name : Positive;
            function Is_White_Space (Ch : Character) return Boolean
            is (Ch = ' ' or else not Ada.Characters.Handling.Is_Graphic (Ch));
         begin
            if Line'Length > 0
              and then (Line (Line'First) /= ' '
                          and Line (Line'First) /= '-'
                          and Line (Line'First) /= '#')
            then
            Find_Name :
               for J in Line'Range loop
                  if Is_White_Space ((Line (J))) then
                     Next_After_Name := J;
                     exit Find_Name;
                  end if;
               end loop Find_Name;
               Parties.Insert
                 (Line (Line'First .. Next_After_Name - 1),
                  (Float'Value (Line (Next_After_Name .. Line'Last)),
                   others => <>));
            end if;
         end;
      exception
         when End_Error => exit Get_Party_Data;
      end;
   end loop Get_Party_Data;

Calculate:
   for Round in 1 .. Number_Of_Seats loop
      declare
         Highest_Polling_This_Round : Float := 0.0;
         Winner : Party_Maps.Cursor;
         use Party_Maps;
      begin
         for P in Parties.Iterate loop
            declare
               Party : Party_Data renames Element (P);
               Adjusted_Polling : constant Float :=
                 Party.Polling / Float (Party.Number_Of_Seats + 1);
            begin
               if Adjusted_Polling > Highest_Polling_This_Round
               then
                  Highest_Polling_This_Round := Adjusted_Polling;
                  Winner := P;
               end if;
            end;
         end loop;
         Parties (Winner).Number_Of_Seats :=
           Parties (Winner).Number_Of_Seats + 1;
         Put_Line ("Winner of round" & Round'Image & " is " & Key (Winner));
      end;
   end loop Calculate;

   New_Line;

   for P in Parties.Iterate loop
      Put_Line (Party_Maps.Key (P)
                  & " win" & Party_Maps.Element (P).Number_Of_Seats'Image
                  & " seats.");
   end loop;
end Dhondt_Calculator;
