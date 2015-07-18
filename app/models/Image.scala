package models

import play.api.libs.json.Json

/**
 * Created by jwhu on 7/16/15.
 */
case class Image(name: String, url: String)

object Image {
  implicit val imageFormat = Json.format[Image]
}