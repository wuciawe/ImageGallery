package models

import play.api.libs.json.Json

/**
 * Created by jwhu on 7/16/15.
 */
case class Folder(id: String, liked: Int, title: String, images: List[Image], index: Int)

object Folder {
  implicit val folderFormat = Json.format[Folder]
}