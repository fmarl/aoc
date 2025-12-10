(**
   Author: Florian Marrero Liestmann <f.m.liestmann@fx-ttr.de>

   This is the solution for the Advent of Code challenge from 02.12.2025, implemented in OCaml.

   Usage:

   find_invalid_ids intervals |> sum_ids;;
 *)

let intervals = "52-75,71615244-71792700,89451761-89562523,594077-672686,31503-39016,733-976,1-20,400309-479672,458-635,836793365-836858811,3395595155-3395672258,290-391,5168-7482,4545413413-4545538932,65590172-65702074,25-42,221412-256187,873499-1078482,118-154,68597355-68768392,102907-146478,4251706-4487069,64895-87330,8664371543-8664413195,4091-5065,537300-565631,77-115,83892238-83982935,6631446-6694349,1112-1649,7725-9776,1453397-1493799,10240-12328,15873-20410,1925-2744,4362535948-4362554186,3078725-3256936,710512-853550,279817-346202,45515-60928,3240-3952"

let (--) i j = 
    let rec aux n acc =
      if n < i then acc else aux (n-1) (n :: acc)
    in aux j []

(* Part 1: Parsing *)
(* First we split the whole string into many interval-strings *)
let intervals_to_list (interval : string) = String.split_on_char ',' interval

(* Next we calculate each interval-string into a interval range. Example:
   ["22-26"] will be [[22; 23; 24; 25; 26]]*)
let interval_str_to_int_range (interval : string) =
  let start_end = String.split_on_char '-' interval in
  let start_of_interval = int_of_string (List.nth start_end 0) in
  let end_of_interval = int_of_string (List.nth start_end 1) in
  start_of_interval -- end_of_interval

(* Bringing it together *)
let intervals_to_interval_ranges (interval : string) =
  List.map interval_str_to_int_range (intervals_to_list interval)

(* Part 2: Filtering *)
(* First we check if the ID String has a symetric lenght. Example:
   22 is symmetric, 4267 is symmetric, 123 is not symmetric

   Unsymmetric strings aren't of interst of us, becase when we split them in half
   they will never be a repeating sequence. *)
let has_symmetric_length (id_string : string) = ((String.length id_string) mod 2) = 0

(* Next we will split the id in half. This is a good way to check if they contain a
   repeating sequence. Example:
   22 -> ("2"; "2") 2532 -> ("25"; "32"), 14321432 -> ("1432"; "1432") *)
let split_id_in_half (id_string : string) =
  let half_len = (String.length id_string) / 2 in
  Pair.make (String.sub id_string 0 half_len) (String.sub id_string half_len half_len)

(* Now we only need to check if the both half matches. *)
let is_invalid_id (id_pair : string * string) = Pair.fst id_pair = Pair.snd id_pair

(* [11; 12; 13; 14 ...]*)
let find_invalid_ids_in_interval (interval : int list) =
  List.filter (fun x ->
      let id_string = string_of_int x in
      if has_symmetric_length id_string then split_id_in_half id_string |> is_invalid_id
      else false) interval

let find_invalid_ids (interval : string) =
  List.map find_invalid_ids_in_interval (intervals_to_interval_ranges interval)

let sum_ids (nested_invalid_ids : int list list) =
  List.flatten nested_invalid_ids |> List.fold_left (+) 0
