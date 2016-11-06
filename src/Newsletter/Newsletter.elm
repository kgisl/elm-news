module Newsletter.Newsletter exposing (Newsletter, Article, fetch)

import Json.Decode exposing (..)
import Http
import Task exposing (Task)
import News.View as News exposing (DisplayStoryFrom)


type alias Newsletter =
    { startDate : String
    , endDate : String
    , year : String
    , articles : List Article
    }


type alias Article =
    { url : String
    , title : String
    , from : DisplayStoryFrom
    , tag : String
    }


fetch : String -> Task Http.Error Newsletter
fetch name =
    Http.get decoder <|
        "https://raw.githubusercontent.com/oakesja/elm-news-newsletters/master/newsletters/"
            ++ name


decoder : Decoder Newsletter
decoder =
    object4 Newsletter
        ("start_date" := string)
        ("end_date" := string)
        ("year" := string)
        ("articles" := list articleDecoder)


articleDecoder : Decoder Article
articleDecoder =
    object4 Article
        ("url" := string)
        ("title" := string)
        fromDecoder
        ("tag" := string)


fromDecoder : Decoder DisplayStoryFrom
fromDecoder =
    oneOf
        [ customDecoder ("author" := string) (Ok << News.Author)
        , customDecoder ("description" := string) (Ok << News.Other)
        , fail "Failed to find an author or description"
        ]