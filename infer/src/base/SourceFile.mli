(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

type t [@@deriving compare, sexp_of]

(** Maps from source_file *)
module Map : Caml.Map.S with type key = t

(** Set of source files *)
module Set : Caml.Set.S with type elt = t

module Hash : Caml.Hashtbl.S with type key = t

val is_invalid : t -> bool
(** Is the source file the invalid source file? *)

val read_config_changed_files : unit -> Set.t option
(** return the list of changed files as read from Config.changed_files_index. NOTE: it may include
    extra source_files if --changed-files-index contains paths to header files. *)

val invalid : string -> t
(** Invalid source file *)

val equal : t -> t -> bool
(** equality of source files *)

val from_abs_path : ?warn_on_error:bool -> string -> t
(** create source file from absolute path. WARNING: If warn_on_error is false, no warning will be
    shown whenever an error occurs for the given path (e.g. if it does not exist). *)

val create : ?warn_on_error:bool -> string -> t
(** Create a SourceFile from a given path. If relative, it assumes it is w.r.t. project root.
    WARNING: If warn_on_error is false, no warning will be shown whenever an error occurs for the
    given path (e.g. if it does not exist). *)

val is_under_project_root : t -> bool
(** Returns true if the file is under the project root or the workspace directory if it exists *)

val of_header : ?warn_on_error:bool -> t -> t option
(** Return approximate source file corresponding to the parameter if it's header file and file
    exists. returns None otherwise. WARNING: If warn_on_error is false, no warning will be shown
    whenever an error occurs for the given SourceFile (e.g. if it does not exist). *)

val pp : Format.formatter -> t -> unit
(** pretty print t *)

val to_abs_path : t -> string
(** get the full path of a source file *)

val to_rel_path : t -> string
(** get the relative path of a source file *)

val to_string : ?force_relative:bool -> t -> string
(** convert a source file to a string WARNING: result may not be valid file path, do not use this
    function to perform operations on filenames *)

val has_extension : ext:string -> t -> bool
(** returns whether the source file has provided extension *)

val is_matching : Str.regexp list -> t -> bool
(** Check if the source file path is matching with a regexp of the given regexp list. *)

module SQLite : SqliteUtils.Data with type t = t

module Normalizer : HashNormalizer.S with type t = t
