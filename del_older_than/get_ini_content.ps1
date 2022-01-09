    <#

    .PARAMETER filePath
    The path to the INI file.
    
    .PARAMETER anonymous
    The section name to use for the anonymous section (keys that come before any section declaration).
    
    .PARAMETER comments
    Enables saving of comments to a comment section in the resulting hash table.
    The comments for each section will be stored in a section that has the same name as the section of its origin, but has the comment suffix appended.
    Comments will be keyed with the comment key prefix and a sequence number for the comment. The sequence number is reset for every section.
    
    .PARAMETER commentsSectionsSuffix
    The suffix for comment sections. The default value is an underscore ('_').
    .PARAMETER commentsKeyPrefix
    The prefix for comment keys. The default value is 'Comment'.

    Used to be:
    # function Get-IniContent {   
#     param(
#         [parameter(Mandatory = $true)] [string] $filePath,
#         [string] $anonymous = 'NoSection',
#         [switch] $comments,
#         [string] $commentsSectionsSuffix = '_',
#         [string] $commentsKeyPrefix = 'Comment'
#     )

#     $ini = @{}
#     switch -regex -file ($filePath) {
#         "^\[(.+)\]$" {
#             # Section
#             $section = $matches[1]
#             $ini[$section] = @{}
#             $CommentCount = 0
#             if ($comments) {
#                 $commentsSection = $section + $commentsSectionsSuffix
#                 $ini[$commentsSection] = @{}
#             }
#             continue
#         }

#         "^(;.*)$" {
#             # Comment
#             if ($comments) {
#                 if (!($section)) {
#                     $section = $anonymous
#                     $ini[$section] = @{}
#                 }
#                 $value = $matches[1]
#                 $CommentCount = $CommentCount + 1
#                 $name = $commentsKeyPrefix + $CommentCount
#                 $commentsSection = $section + $commentsSectionsSuffix
#                 $ini[$commentsSection][$name] = $value
#             }
#             continue
#         }

#         "^(.+?)\s*=\s*(.*)$" {
#             # Key
#             if (!($section)) {
#                 $section = $anonymous
#                 $ini[$section] = @{}
#             }
#             $name, $value = $matches[1..2]
#             $ini[$section][$name] = $value
#             continue
#         }
#     }

#     return $ini
# }
    #>


param(
    [parameter(Mandatory = $true)] [string] $filePath,
    [string] $anonymous = 'NoSection',
    [switch] $comments,
    [string] $commentsSectionsSuffix = '_',
    [string] $commentsKeyPrefix = 'Comment'
)

$ini = @{}
switch -regex -file ($filePath) {
    "^\[(.+)\]$" {
        # Section
        $section = $matches[1]
        $ini[$section] = @{}
        $CommentCount = 0
        if ($comments) {
            $commentsSection = $section + $commentsSectionsSuffix
            $ini[$commentsSection] = @{}
        }
        continue
    }

    "^(;.*)$" {
        # Comment
        if ($comments) {
            if (!($section)) {
                $section = $anonymous
                $ini[$section] = @{}
            }
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = $commentsKeyPrefix + $CommentCount
            $commentsSection = $section + $commentsSectionsSuffix
            $ini[$commentsSection][$name] = $value
        }
        continue
    }

    "^(.+?)\s*=\s*(.*)$" {
        # Key
        if (!($section)) {
            $section = $anonymous
            $ini[$section] = @{}
        }
        $name, $value = $matches[1..2]
        $ini[$section][$name] = $value
        continue
    }
}

return $ini