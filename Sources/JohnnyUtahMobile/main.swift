import Foundation
import Publish
import Plot
import SwiftPygmentsPublishPlugin
import ReadingTimePublishPlugin


// This type acts as the configuration for your website.
struct JohnnyUtahMobile: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
        case contact
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var name = "Johnny Mobile Software Engineer"
    var description = "A collection of personal thoughts on software engineering and building mobile applications."
    var language: Language { .english }
    var imagePath: Path? { nil }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .p(.text(item.description))
                ))
            }
        )
    }
}

extension Node where Context == HTML.BodyContext {
    static func myHeader<T: Website>(for context: PublishingContext<T>) -> Node {
        
        .header(
            .wrapper(
                .nav(
                    .class("site-name"),
                    .a(
                        .href("/"),
                        .text(context.site.name)
                    )
                ) //nav
            ) //wrapper
        ) //header
        
    }
}


struct MYHtmlFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: index, on: context.site),
            .body(
                .myHeader(for: context),
                .wrapper(
                    .ul(
                        .class("item-list"),
                        .forEach(
                            context.allItems(sortedBy: \.date, order: .descending)
                        ) {
                            item in
                            .li(
                                .article(
                                    .h1(.a(
                                        .href(item.path),
                                        .text(item.title)
                                    )),
                                    .p(.text(item.description))
                                ) //article
                            ) //li
                        }
                    ) //ul
                )
            ) // body
        ) //HTML
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .head(for: item, on: context.site),
            .body(
                .myHeader(for: context),
                .wrapper(
                    .article(
                        .contentBody(item.body)))
            )
            
            
            )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}

extension Theme {
    static var myTheme: Theme {
        Theme(htmlFactory: MYHtmlFactory(),
              resourcePaths: ["Resources/MyTheme/styles.css"])
    }
    
}
// This will generate your website using the built-in Foundation theme:
try JohnnyUtahMobile().publish(withTheme: .myTheme,
                               deployedUsing: .gitHub("johnnyutah22/johnnyutah22.github.io"),
                                   additionalSteps: [
                                       .installPlugin(.readingTime()),
                                       .installPlugin(.pygments()),
                                   ],
                                   plugins: [.pygments()]
                               )
