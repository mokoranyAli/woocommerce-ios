import Foundation
import Alamofire


/// Enum containing the available moderation statuses
///
public enum CommentStatus: String {

    /// Approve the comment.
    ///
    case approved

    /// Remove the comment from public view and send it to the moderation queue.
    ///
    case unapproved

    /// Mark the comment as spam.
    ///
    case spam

    /// Unmark the comment as spam. Will attempt to set it to the previous status.
    ///
    case unspam

    /// Send a comment to the trash if trashing is enabled.
    ///
    case trash

    /// Untrash a comment. Only works when the comment is in the trash.
    ///
    case untrash

    /// No idea what status this is. Note: this specific case is used when parsing the response from the server.
    ///
    case unknown
}

/// Comment: Remote Endpoints
///
public class CommentRemote: Remote {

    /// Moderate a comment
    ///
    /// - Parameters:
    ///   - siteID: site ID which contains the comment
    ///   - commentID: ID of the comment to moderate
    ///   - status: New status for comment
    ///   - completion: callback to be executed on completion
    ///
    public func moderateComment(siteID: Int, commentID: Int, status: CommentStatus, completion: @escaping (CommentStatus, Error?) -> Void) {
        let path = "\(Paths.sites)/" + String(siteID) + "/" + "\(Paths.comments)/" + String(commentID)
        let parameters = [
            ParameterKeys.status: status.rawValue,
            ParameterKeys.context: ParameterValues.edit
        ]
        let mapper = CommentResultMapper()
        let request = DotcomRequest(wordpressApiVersion: .mark1_1, method: .post, path: path, parameters: parameters)
        enqueue(request, mapper: mapper, completion: completion)
    }
}


// MARK: - Constants!
//
public extension CommentRemote {
    private enum Paths {
        static let sites: String        = "sites"
        static let comments: String     = "comments"
    }

    private enum ParameterKeys {
        static let status: String       = "status"
        static let context: String      = "context"
    }

    private enum ParameterValues {
        static let edit: String       = "edit"
    }
}
