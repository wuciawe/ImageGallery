package models

import play.api.libs.json.Json

/**
 * Created by jwhu on 8/4/15.
 */
case class Vote(collection: String, up: Boolean)
object Vote {
  implicit val voteFormat = Json.format[Vote]
}