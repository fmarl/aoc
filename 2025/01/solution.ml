(**
   Author: Florian Marrero Liestmann <f.m.liestmann@fx-ttr.de>

   This is the solution for the Advent of Code challenge from 01.12.2025, implemented in OCaml.

   Usage:

   let lst = parse_file "./input"
   in Dial.zeros (Dial.fold lst)
 *)

type ops = R of int | L of int

module Dial = struct
  type int
  
  let max = 100
  let init = 50
  
  let r x y = (y + x) mod max
  let l x y = (y - x) mod max
  
  let fold lst =
    let rec folder x = function
      | [] -> []
      | R n :: xs ->
         let x' = r n x in
         x' :: folder x' xs
      | L n :: xs ->
         let x' = l n x in
         x' :: folder x' xs
    in
    folder init lst

  let zeros x = List.length (List.filter (fun x -> x = 0) x)
end

(* Parse a single line like "R3" or "L42" *)
let parse_line line =
  if String.length line < 2 then
    failwith ("Invalid command: " ^ line);
  let c = line.[0] in
  let n = int_of_string (String.sub line 1 (String.length line - 1)) in
  match c with
  | 'R' -> R n
  | 'L' -> L n
  | _ -> failwith ("Unknown command: " ^ line)

(* Read all commands from a file *)
let parse_file filename =
  let ch = open_in filename in
  let rec loop acc =
    match input_line ch with
    | line ->
        let line = String.trim line in
        if line = "" then
          loop acc    (* Skip empty lines *)
        else
          loop (parse_line line :: acc)
    | exception End_of_file ->
        close_in ch;
        List.rev acc
  in
  loop []
