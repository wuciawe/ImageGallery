package controllers

import javax.inject.Inject
import play.modules.reactivemongo.json.collection.JsCursor._
import play.modules.reactivemongo.json._
import play.modules.reactivemongo.json.collection._
import org.slf4j.{LoggerFactory, Logger}
import play.api.libs.json._
import play.api.mvc._
import play.modules.reactivemongo.{ReactiveMongoApi, ReactiveMongoComponents, MongoController}
import play.modules.reactivemongo.json.collection.JSONCollection
import reactivemongo.api.ReadPreference
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import scalaz._

/**
 * Created by jwhu on 7/16/15.
 */
class Data @Inject() (val reactiveMongoApi: ReactiveMongoApi) extends Controller with MongoController with ReactiveMongoComponents {
  private final val logger: Logger = LoggerFactory.getLogger(classOf[Data])

//  def collection = Memo.mutableHashMapMemo[String, JSONCollection] {
//    case collectionName: String => db.collection[JSONCollection](collectionName)
//  }

  def getJsonData(collectionName: String) = Action.async {
//    collection(collectionName)
    db.collection[JSONCollection](collectionName)
      .find(Json.obj(), Json.obj("title" -> 1, "images" -> 1, "liked" -> 1))
      .cursor[JsObject](ReadPreference.primaryPreferred)
      .collect[List]()
      .map(_.foldLeft(JsArray())((acc, x) => acc ++ Json.arr(x)))
      .map(Ok(_))
  }

}